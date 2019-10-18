import Foundation
import Network

/// Service that fetches and stores PaymentSession.
/// Used by `PaymentListViewController`
class PaymentSessionService {
	private let paymentSessionProvider: PaymentSessionProvider
	private let downloadProvider: NetworkDownloadProvider
	
	init(paymentSessionProvider: PaymentSessionProvider, downloadProvider: NetworkDownloadProvider) {
		self.paymentSessionProvider = paymentSessionProvider
		self.downloadProvider = downloadProvider
	}
	
	func loadPaymentSession(completion: @escaping ((Load<PaymentSession>) -> Void)) {
		paymentSessionProvider.loadPaymentSession(completion: completion)
	}
	
	func loadLogo(for network: PaymentNetwork, completion: @escaping ((Data?) -> Void)) {
		guard let logoURL = network.applicableNetwork.links?["logo"] else {
			completion(nil)
			return
		}
		
		downloadProvider.downloadData(from: logoURL) { result in
			switch result {
			case .success(let logoData):
				completion(logoData)
			case .failure(let error):
				log(.error, "Couldn't download a logo for a payment network %@ from %@, reason: %@", network.code, logoURL.absoluteString, error.localizedDescription)
				completion(nil)
			}
		}
	}
}

