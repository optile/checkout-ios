import Foundation

class PaymentSessionProvider {
    private let paymentSessionURL: URL
    private let sharedTranslationProvider: SharedTranslationProvider

    let connection: Connection
    
    init(paymentSessionURL: URL, connection: Connection, localizationsProvider: SharedTranslationProvider) {
        self.paymentSessionURL = paymentSessionURL
        self.connection = connection
        self.sharedTranslationProvider = localizationsProvider
    }

    func loadPaymentSession(completion: @escaping ((Load<PaymentSession, Error>) -> Void)) {
        completion(.loading)

        let job = getListResult ->> downloadSharedLocalization ->> checkInteractionCode ->> filterUnsupportedNetworks ->> localize

        job(paymentSessionURL) { [weak self] result in
            guard let weakSelf = self else { return }
            
            switch result {
            case .success(let paymentNetworks):
                let paymentSession = weakSelf.createPaymentSession(from: paymentNetworks)
                completion(.success(paymentSession))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Asynchronous methods

    private func getListResult(from url: URL, completion: @escaping ((Result<ListResult, Error>) -> Void)) {
        let getListResult = GetListResult(url: paymentSessionURL)
        let getListResultOperation = SendRequestOperation(connection: connection, request: getListResult)
        getListResultOperation.downloadCompletionBlock = { result in
            switch result {
            case .success(let listResult): completion(.success(listResult))
            case .failure(let error): completion(.failure(error))
            }
        }
        getListResultOperation.start()
    }

    private func downloadSharedLocalization(for listResult: ListResult, completion: @escaping ((Result<ListResult, Error>) -> Void)) {
        guard let localeURL = listResult.networks.applicable.first?.links?[
            "lang"] else {
                let error = InternalError(description: "Applicable network language URL wasn't provided to a localization provider")
                completion(.failure(error))
                return
        }

        sharedTranslationProvider.download(from: localeURL, using: connection) { error in
            if let error = error {
                completion(.failure(error))
                return
            }

            // Just bypass in to out
            completion(.success(listResult))
        }
    }

    private func checkInteractionCode(listResult: ListResult, completion: ((Result<ListResult, Error>) -> Void)) {
        if listResult.interaction.interactionCode == .some(.PROCEED) {
            completion(.success(listResult))
            return
        }
        
        let localizedReason: String? =
            sharedTranslationProvider.translation(forKey: listResult.interaction.code + "." + listResult.interaction.reason)

        let error: Error
        if let localizedReason = localizedReason {
            // If we have a localization for that interaction throw it as an error
            error = PaymentError(localizedDescription: localizedReason)
        } else {
            // If we don't have such localization throw an internal error, later it would be converted to a generic error
            error = InternalError(description: "%@", listResult.interaction.reason)
        }

        completion(.failure(error))
    }

    private typealias APINetworksTuple = (applicableNetworks: [ApplicableNetwork], accountRegistrations: [AccountRegistration])
    
    private func filterUnsupportedNetworks(listResult: ListResult, completion: ((APINetworksTuple) -> Void)) {
        // swiftlint:disable:next line_length
        let supportedCodes = ["AMEX", "CASTORAMA", "DINERS", "DISCOVER", "MASTERCARD", "UNIONPAY", "VISA", "VISA_DANKORT", "VISAELECTRON", "CARTEBANCAIRE", "MAESTRO", "MAESTROUK", "POSTEPAY", "SEPADD", "JCB"]

        let filteredPaymentNetworks = listResult.networks.applicable
            .filter { supportedCodes.contains($0.code) }
        
        let filteredRegisteredNetworks: [AccountRegistration]
        if let accounts = listResult.accounts {
            filteredRegisteredNetworks = accounts.filter { supportedCodes.contains($0.code) }
        } else {
            filteredRegisteredNetworks = .init()
        }
        
        completion((filteredPaymentNetworks, filteredRegisteredNetworks))
    }
    
    private func localize(tuple: APINetworksTuple, completion: @escaping (Result<DownloadTranslationService.Translations, Error>) -> Void) {
        let translationService = DownloadTranslationService(networks: tuple.applicableNetworks, accounts: tuple.accountRegistrations, sharedTranslation: sharedTranslationProvider)
        translationService.localize(using: connection, completion: completion)
    }
    
    // MARK: - Synchronous methods
    
    private func createPaymentSession(from translations: DownloadTranslationService.Translations) -> PaymentSession {
        return .init(networks: translations.networks, accounts: translations.accounts)
    }
}
