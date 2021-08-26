// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

class PaymentSessionProvider {
    private let paymentSessionURL: URL
    private let sharedTranslationProvider: SharedTranslationProvider
    private let paymentServicesFactory: PaymentServicesFactory

    let connection: Connection

    var listResult: ListResult?

    init(paymentSessionURL: URL, connection: Connection, paymentServicesFactory: PaymentServicesFactory, localizationsProvider: SharedTranslationProvider) {
        self.paymentSessionURL = paymentSessionURL
        self.connection = connection
        self.sharedTranslationProvider = localizationsProvider
        self.paymentServicesFactory = paymentServicesFactory
    }

    func loadPaymentSession(completion: @escaping ((Load<PaymentSession, Error>) -> Void)) {
        completion(.loading)

        let job = getListResult ->> checkIntegrationType ->> checkOperationType ->> downloadSharedLocalization ->> checkInteractionCode ->> filterUnsupportedNetworks ->> localize

        job(paymentSessionURL) { [weak self] result in
            guard let weakSelf = self else { return }

            switch result {
            case .success(let paymentNetworks):
                do {
                    let paymentSession = try weakSelf.createPaymentSession(from: paymentNetworks)
                    completion(.success(paymentSession))
                } catch {
                    completion(.failure(error))
                }
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
            case .success(let listResult):
                self.listResult = listResult
                completion(.success(listResult))
            case .failure(let error): completion(.failure(error))
            }
        }
        getListResultOperation.start()
    }

    private func checkIntegrationType(for listResult: ListResult, completion: ((Result<ListResult, Error>) -> Void)) {
        guard listResult.integrationType == "MOBILE_NATIVE" else {
            let interaction = Interaction(code: .ABORT, reason: .CLIENTSIDE_ERROR)
            let resultInfo = "Integration type is not supported: " + listResult.integrationType
            let paymentError = CustomErrorInfo(resultInfo: resultInfo, interaction: interaction, underlyingError: nil)
            completion(.failure(paymentError))
            return
        }

        completion(.success(listResult))
    }

    private func checkOperationType(for listResult: ListResult, completion: @escaping ((Result<ListResult, Error>) -> Void)) {
        guard listResult.operationType != nil else {
            let error = InternalError(description: "Operation type is not specified")
            completion(.failure(error))
            return
        }

        completion(.success(listResult))
    }

    private func downloadSharedLocalization(for listResult: ListResult, completion: @escaping ((Result<ListResult, Error>) -> Void)) {
        guard let localeURL = listResult.links["lang"] else {
                let error = InternalError(description: "ListResult doesn't contain localization url")
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
        guard Interaction.Code(rawValue: listResult.interaction.code) == .some(.PROCEED) else {
            // If result is not PROCEED, route interaction and resultInfo to a merchant
            let errorInfo = CustomErrorInfo(resultInfo: listResult.resultInfo, interaction: listResult.interaction, underlyingError: nil)
            completion(.failure(errorInfo))
            return
        }

        // Interaction code is PROCEED, route result
        completion(.success(listResult))
    }

    private typealias APINetworksTuple = (applicableNetworks: [ApplicableNetwork], accountRegistrations: [AccountRegistration])

    private func filterUnsupportedNetworks(listResult: ListResult, completion: ((APINetworksTuple) -> Void)) {
        // Filter networks unsupported by any of `PaymentService`
        var filteredPaymentNetworks = listResult.networks.applicable.filter { network in
            paymentServicesFactory.isSupported(networkCode: network.code, paymentMethod: network.method)
        }

        // Filter networks with `NONE/NONE` registration options in `UPDATE` flow, more info at: [PCX-1396](https://optile.atlassian.net/browse/PCX-1396) AC #1.a
        if listResult.operationType == "UPDATE" {
            filteredPaymentNetworks = filteredPaymentNetworks.filter { network in
                if case .NONE = network.registrationRequirement, case .NONE = network.recurrenceRequirement {
                    return false
                } else {
                    return true
                }
            }
        }

        let filteredRegisteredNetworks: [AccountRegistration]
        if let accounts = listResult.accounts {
            filteredRegisteredNetworks = accounts.filter {
                paymentServicesFactory.isSupported(networkCode: $0.code, paymentMethod: $0.method)
            }
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

    private func createPaymentSession(from translations: DownloadTranslationService.Translations) throws -> PaymentSession {
        guard let operationType = listResult?.operationType else {
            throw InternalError(description: "Operation type or ListResult is not defined")
        }

        // PaymentSession.Operation contains only supported operation types by the framework
        guard let operation = PaymentSession.Operation(rawValue: operationType) else {
            throw InternalError(description: "Operation type is not known or supported: %@", operationType)
        }

        let context = PaymentContext(operationType: operation, extraElements: listResult?.extraElements)

        return .init(networks: translations.networks, accounts: translations.accounts, context: context)
    }
}
