import Foundation
import Network

class PaymentSessionProvider {
	private let paymentSessionURL: URL
	private let localizationQueue = OperationQueue()
	private var sharedLocalizations: [Dictionary<String, String>] = []
	
	init(paymentSessionURL: URL) {
		self.paymentSessionURL = paymentSessionURL
	}
	
	func loadPaymentSession(completion: @escaping ((Load<PaymentSession>) -> Void)) {
		completion(.loading)

		let job = getListResult ->> transformToUIModel ->> downloadSharedLocalization ->> downloadLocalizations
				
		job(paymentSessionURL) { result in
			switch result {
			case .success(let session): completion(.success(session))
			case .failure(let error): completion(.failure(error))
			}
		}
	}
	
	// MARK: - Closures
	
	private func getListResult(from url: URL, completion: @escaping ((Result<ListResult, Error>) -> Void)) {
		let getListResult = GetListResult(url: url)
		let getListResultOperation = SendRequestOperation(request: getListResult)
		getListResultOperation.downloadCompletionBlock = completion
		getListResultOperation.start()
	}
	
	private func transformToUIModel(listResult: ListResult, completion: ((PaymentSession) -> Void)) {
		let supportedCodes = ["AMEX", "CASTORAMA", "DINERS", "DISCOVER", "MASTERCARD", "UNIONPAY", "VISA", "VISA_DANKORT", "VISAELECTRON", "CARTEBANCAIRE", "MAESTRO", "MAESTROUK", "POSTEPAY", "SEPADD", "JCB"]

		let filteredPaymentNetworks = listResult.networks.applicable
										.filter { supportedCodes.contains($0.code) }
										.map { PaymentNetwork(from: $0) }
		
		completion(PaymentSession(networks: filteredPaymentNetworks))
	}
	
	private func downloadSharedLocalization(for session: PaymentSession, completion: @escaping ((Result<PaymentSession, Error>) -> Void)) {
		guard let localeURL = session.networks.first?.localeURL else {
			let error = PaymentInternalError(description: "Applicable network language URL wasn't provided to localization provider")
			completion(.failure(error))
			return
		}
		
		let provider = SharedLocalizationProvider()
		
		provider.download(using: localeURL) { result in
			switch result {
			case .success(let localizations):
				self.sharedLocalizations = localizations
				completion(.success(session))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	private func downloadLocalizations(for session: PaymentSession, completion: @escaping ((PaymentSession) -> Void)) {
		var allOperations: [LocalizeModelOperation<PaymentNetwork>] = []
		
		let completionOperation = BlockOperation {
			let localizedModels = allOperations.compactMap { $0.localizedModel }
			var localizedSession = session
			localizedSession.networks = localizedModels
			completion(localizedSession)
		}
		
		for network in session.networks {
			let operation = LocalizeModelOperation(network)
			operation.sharedLocalizations = sharedLocalizations
			
			allOperations.append(operation)
			completionOperation.addDependency(operation)
			
			localizationQueue.addOperation(operation)
		}
		
		localizationQueue.addOperation(completionOperation)
	}
}
