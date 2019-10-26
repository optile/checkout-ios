import Foundation

class PaymentSessionProvider {
	private let paymentSessionURL: URL
	private let localizationQueue = OperationQueue()
	private let localizationsProvider: SharedTranslationProvider
	private let localizer: Localizer
	
	let connection: Connection
	
	init(paymentSessionURL: URL, connection: Connection, localizationsProvider: SharedTranslationProvider) {
		self.paymentSessionURL = paymentSessionURL
		self.connection = connection
		self.localizationsProvider = localizationsProvider
		self.localizer = Localizer(provider: localizationsProvider)
	}
	
	func loadPaymentSession(completion: @escaping ((Load<PaymentSession>) -> Void)) {
		completion(.loading)

		let job = getListResult ->> downloadSharedLocalization ->> checkInteractionCode ->> filterUnsupportedNetworks ->> downloadLocalizations

		job(paymentSessionURL) { result in
			switch result {
			case .success(let session): completion(.success(session))
			case .failure(let error): completion(.failure(error))
			}
		}
	}
	
	// MARK: - Closures
	
	func getListResult(from url: URL, completion: @escaping ((Result<ListResult, Error>) -> Void)) {
		let getListResult = GetListResult(url: paymentSessionURL)
		let getListResultOperation = SendRequestOperation(connection: connection, request: getListResult)
		getListResultOperation.downloadCompletionBlock = { [localizer] result in
			switch result {
			case .success(let listResult): completion(.success(listResult))
			case .failure(let error):
				log(.error, "getListResultOperation failed: %@", error.localizedDescription)

				var error = LocalizableError(localizationKey: .errorConnection, isRetryable: true)
				error.underlyingError = error
				localizer.localize(model: &error)

				completion(.failure(error))
			}
		}
		getListResultOperation.start()
	}
	
	func downloadSharedLocalization(for listResult: ListResult, completion: @escaping ((Result<ListResult, Error>) -> Void)) {
		guard let localeURL = listResult.networks.applicable.first?.links?[
			"lang"] else {
			log(.fault, "Applicable network language URL wasn't provided to a localization provider")
			
			var error = LocalizableError(localizationKey: .errorDefault)
			localizer.localize(model: &error)

			completion(.failure(error))
			return
		}
		
		localizationsProvider.download(from: localeURL, using: connection) { error in
			if let error = error {
				completion(.failure(error))
				return
			}
			
			// Just bypass in to out
			completion(.success(listResult))
		}
	}
	
	private func checkInteractionCode(listResult: ListResult, completion: ((Result<ListResult, Error>) -> Void)) {
		if listResult.interaction.code == "PROCEED" {
			completion(.success(listResult))
			return
		}
		let localizedInteraction =
			localizer.localize(model: listResult.interaction.localizable)
		let error = PaymentError(localizedDescription: localizedInteraction.localizedDescription)
		completion(.failure(error))
	}
	
	private func filterUnsupportedNetworks(listResult: ListResult, completion: (([ApplicableNetwork]) -> Void)) {
		let supportedCodes = ["AMEX", "CASTORAMA", "DINERS", "DISCOVER", "MASTERCARD", "UNIONPAY", "VISA", "VISA_DANKORT", "VISAELECTRON", "CARTEBANCAIRE", "MAESTRO", "MAESTROUK", "POSTEPAY", "SEPADD", "JCB"]

		let filteredPaymentNetworks = listResult.networks.applicable
										.filter { supportedCodes.contains($0.code) }
		
		completion(filteredPaymentNetworks)
	}
	
	private func downloadLocalizations(for applicableNetworks: [ApplicableNetwork], completion: @escaping ((PaymentSession) -> Void)) {
		var allOperations: [LocalizeModelOperation<PaymentNetwork>] = []
		
		let completionOperation = BlockOperation {
			let localizedModels = allOperations.compactMap { $0.localizedModel }
			let session = PaymentSession(networks: localizedModels)
			completion(session)
		}
		
		for applicableNetwork in applicableNetworks {
			let network = PaymentNetwork(from: applicableNetwork)
			let operation = LocalizeModelOperation(
				network,
				downloadFrom: applicableNetwork.links?["lang"],
				using: connection,
				additionalProvider: localizationsProvider
			)
			
			allOperations.append(operation)
			completionOperation.addDependency(operation)
			
			localizationQueue.addOperation(operation)
		}
		
		localizationQueue.addOperation(completionOperation)
	}
}
