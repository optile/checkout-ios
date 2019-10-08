import Foundation
import Network

class PaymentSessionStore {
	@CurrentValue var sessionState: Load<PaymentSession> = .inactive
	private let paymentSessionURL: URL

	init(paymentSessionURL: URL) {
		self.paymentSessionURL = paymentSessionURL
	}
	
	func loadPaymentSession() {
		let sessionProvider = PaymentSessionProvider(paymentSessionURL: paymentSessionURL)
		sessionState = .loading

		sessionProvider.download { [weak self] result in
			switch result {
			case .success(let session): self?.sessionState = .success(session)
			case .failure(let error): self?.sessionState = .failure(error)
			}
		}
	}
}

// MARK: -

private class PaymentSessionProvider {
	private let paymentSessionURL: URL
	private var downloadedNetworks = [PaymentNetwork]()
	private let operationQueue = OperationQueue()
	
	init(paymentSessionURL: URL) {
		self.paymentSessionURL = paymentSessionURL
	}
	
	public func download(completion: @escaping ((Result<PaymentSession, Error>) -> Void)) {
		// 1. Download session
		let getListResult = GetListResult(url: paymentSessionURL)
		let sendBackendRequestOperation = DownloadOperation(request: getListResult)
		
		sendBackendRequestOperation.downloadCompletionBlock = { [self] result in
			switch result {
			case .success(let listResult):
				// 3. Exit the method (send completion with localized PaymentSession)
				let sendCompletionBlockOperation = BlockOperation {
					let paymentSession = PaymentSession(networks: self.downloadedNetworks)
					completion(.success(paymentSession))
					self.downloadedNetworks = [PaymentNetwork]()
				}

				// 2. Download localizations (will be added to downloadedNetworks)
				for network in listResult.networks.applicable {
					guard let langLink = network.links?.lang else {
						log(.error, "Missing a language file's link in ApplicableNetworks for '%{public}@'", network.code)
						continue
					}
					
					let downloadLocalization = self.makeDownloadLocalizationOperation(for: network, from: langLink)
					sendCompletionBlockOperation.addDependency(downloadLocalization)
					self.operationQueue.addOperation(downloadLocalization)
				}
				
				// Add pre-created finish operation
				self.operationQueue.addOperation(sendCompletionBlockOperation)
			case .failure(let error):
				completion(.failure(error))
			}
		}
		
		operationQueue.addOperation(sendBackendRequestOperation)
	}
	
	private func makeDownloadLocalizationOperation(for network: ApplicableNetwork, from langURL: URL) -> Operation {
		let downloadLocalizationRequest = DownloadLocalization(url: langURL)
		let downloadOperation = DownloadOperation(request: downloadLocalizationRequest)
		downloadOperation.downloadCompletionBlock = { result in
			switch result {
			case .success(let languageDictionary):
				guard let paymentNetwork = PaymentNetwork(importFrom: network, localizationDictionary: languageDictionary) else {
					return
				}
				
				self.downloadedNetworks.append(paymentNetwork)
			case .failure(let error):
				log(.error, "Error downloading localization file for '%{public}@': %@", network.code, error.localizedDescription)
			}
		}
		
		return downloadOperation
	}
}

// MARK: - Import extensions

private extension PaymentNetwork {
	init?(importFrom applicableNetwork: ApplicableNetwork, localizationDictionary: Dictionary<String, String>) {
		guard let localizedLabel = localizationDictionary[LocalizationKey.label.rawValue] else {
			log(.error, "Unable to find `%{public}@` in localization dictionary for %@", PaymentNetwork.LocalizationKey.label.rawValue, applicableNetwork.code)
			return nil
		}
		
		self.init(label: localizedLabel, logoURL: applicableNetwork.links?.logo)
	}
}
