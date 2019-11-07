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
	
	func loadPaymentSession(completion: @escaping ((Load<PaymentSession, Error>) -> Void)) {
		completion(.loading)

		let job = getListResult ->> downloadSharedLocalization ->> checkInteractionCode ->> filterUnsupportedNetworks ->> transformToUIModel ->> downloadLocalizations ->> makePaymentSession

		job(paymentSessionURL) { result in
			switch result {
			case .success(let session): completion(.success(session))
			case .failure(let error): completion(.failure(error))
			}
		}
	}
	
	// MARK: - Closures
	
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
		if listResult.interaction.interactionCode == .some(.PROCEED) {
			completion(.success(listResult))
			return
		}
		
		// Non-proceed interaction, throw an error
		
		let localizedInteraction =
			localizer.localize(model: listResult.interaction.localizable)
		
		let error: Error
		if !localizedInteraction.localizedDescription.isEmpty {
			// If we have a localization for that interaction throw it as an error
			error = PaymentError(localizedDescription: localizedInteraction.localizedDescription)
		} else {
			// If we don't have such localization throw an internal error, later it would be converted to a generic error
			error = InternalError(description: "%@", listResult.interaction.reason)
		}
		
		completion(.failure(error))
	}
	
	private func filterUnsupportedNetworks(listResult: ListResult, completion: (([ApplicableNetwork]) -> Void)) {
		let supportedCodes = ["AMEX", "CASTORAMA", "DINERS", "DISCOVER", "MASTERCARD", "UNIONPAY", "VISA", "VISA_DANKORT", "VISAELECTRON", "CARTEBANCAIRE", "MAESTRO", "MAESTROUK", "POSTEPAY", "SEPADD", "JCB"]

		let filteredPaymentNetworks = listResult.networks.applicable
										.filter { supportedCodes.contains($0.code) }
		
		completion(filteredPaymentNetworks)
	}
	
	private func transformToUIModel(applicableNetworks: [ApplicableNetwork], completion: @escaping ((Result<[PaymentNetwork: URL], Error>) -> Void)) {
		var localizationURLsByNetwork = [PaymentNetwork: URL]()
		
		for applicableNetwork in applicableNetworks {
			guard let localizationURL = applicableNetwork.links?["lang"] else {
				let error = InternalError(description: "Applicable network doesn't contain localization URL. Network: %@", objects: applicableNetwork)
				completion(.failure(error))
				return
			}
			
			let paymentNetwork = PaymentNetwork(from: applicableNetwork)
			localizationURLsByNetwork[paymentNetwork] = localizationURL
		}
		
		completion(.success(localizationURLsByNetwork))
	}
	
	private func downloadLocalizations(for networksWithURL: [PaymentNetwork: URL], completion: @escaping ((Result<[PaymentNetwork], Error>) -> Void)) {
		var allOperations: [LocalizeModelOperation<PaymentNetwork>] = []
		
		let completionOperation = BlockOperation {
			var localizedModels = [PaymentNetwork]()
			for operation in allOperations {
				switch operation.localizationResult {
				case .success(let network): localizedModels.append(network)
				case .failure(let error):
					completion(.failure(error))
					return
				case .none:
					let error = InternalError(description: "Model wasn't localized %@", objects: operation.modelToLocalize)
					completion(.failure(error))
					return
				}
			}
			
			completion(.success(localizedModels))
		}
		
		for (network, localizationURL) in networksWithURL {
			let operation = LocalizeModelOperation(
				network,
				downloadFrom: localizationURL,
				using: connection,
				additionalProvider: localizationsProvider
			)
			
			allOperations.append(operation)
			completionOperation.addDependency(operation)
			
			localizationQueue.addOperation(operation)
		}
		
		localizationQueue.addOperation(completionOperation)
	}
	
	private func makePaymentSession(from paymentNetworks: [PaymentNetwork], completion: ((PaymentSession) -> Void)) {
		let session = PaymentSession(networks: paymentNetworks)
		completion(session)
	}
}

private extension Interaction {
	var localizable: LocalizableInteraction {
		.init(code: code, reason: reason)
	}
}
