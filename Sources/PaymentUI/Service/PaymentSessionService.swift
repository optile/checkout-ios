#if canImport(UIKit)

import Foundation
import Network

/// Service that fetches and stores PaymentSession.
/// Used by `PaymentListViewController`
class PaymentSessionService {
	@CurrentValue var sessionState: Load<PaymentSession> = .inactive
	private let paymentSessionURL: URL
	
	private var localizedNetworks = [PaymentNetwork]()
	private var localizationProvider: LocalizationProvider?

	init(paymentSessionURL: URL) {
		self.paymentSessionURL = paymentSessionURL
	}
	
	func loadPaymentSession() {
		localizedNetworks = [PaymentNetwork]()
		sessionState = .loading
		
		// Get list result
		let getListResult = GetListResult(url: paymentSessionURL)
		let getListResultOperation = DownloadOperation(request: getListResult)
		getListResultOperation.downloadCompletionBlock = { [weak self] result in
			let listResult: ListResult
			switch result {
			case .success(let successListResult): listResult = successListResult
			case .failure(let error):
				self?.sessionState = .failure(error)
				return
			}
			
			// Prepare localization provider
			let languageLink = listResult.networks.applicable.first?.links?["lang"]
			guard let url = languageLink else {
				let error = PaymentInternalError(description: "Applicable network language URL wasn't provided to localization provider")
				self?.sessionState = .failure(error)
				return
			}
			
			// Download shared localization
			LocalizationProvider.initalize(anyApplicableNetworkLangURL: url) { provider in
				let paymentNetworks = listResult.networks.applicable.map { PaymentNetwork(from: $0) }
				
				// Localize each network
				let service = LocalizationService(provider: provider)
				service.localize(models: paymentNetworks) { localizedPaymentNetworks in
					let session = PaymentSession(networks: localizedPaymentNetworks)
					self?.sessionState = .success(session)
					
					// Download images
					let imageProvider = ImageProvider()
	
					for network in localizedPaymentNetworks {
						imageProvider.downloadImage(for: network) { image in
							network.logo = image
						}
					}
				}
			}
		}
		
		getListResultOperation.start()
	}
}

// MARK: -

/// Provider responsible for asynchronous image fetching
private class ImageProvider {
	private let operationQueue = OperationQueue()
	
	func downloadImage(for network: PaymentNetwork, completion: @escaping ((UIImage?) -> Void)) {
		guard let imageURL = network.applicableNetwork.links?["logo"], network.logo == nil else {
			completion(nil)
			return
		}
		
		let downloadRequest = DownloadData(from: imageURL)
		let downloadOperation = DownloadOperation(request: downloadRequest)
		downloadOperation.downloadCompletionBlock = { result in
			let image: UIImage?
			
			switch result {
			case .success(let data):
				guard let convertedImage = UIImage(data: data) else {
					log(.error, "Unable to convert data to image")
					image = nil
					return
				}
				
				image = convertedImage
			case .failure(let error):
				log(.error, "Error downloading data: %@", error.localizedDescription)
				image = nil
			}
			
			completion(image)
		}
		
		operationQueue.addOperation(downloadOperation)
	}
}

#endif
