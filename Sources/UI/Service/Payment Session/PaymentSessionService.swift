import Foundation

/// Service that fetches and stores PaymentSession.
/// Used by `PaymentListViewController`
class PaymentSessionService {
	private let paymentSessionProvider: PaymentSessionProvider
	private let downloadProvider: NetworkDownloadProvider
	private let localizationProvider: TranslationProvider
	
	init(paymentSessionURL: URL, connection: Connection, localizationProvider: SharedTranslationProvider) {
		downloadProvider = NetworkDownloadProvider(connection: connection)
		paymentSessionProvider = PaymentSessionProvider(paymentSessionURL: paymentSessionURL, connection: connection, localizationsProvider: localizationProvider)
		self.localizationProvider = localizationProvider
	}
	
	func loadPaymentSession(completion: @escaping ((Load<PaymentSession, PaymentError>) -> Void)) {
		paymentSessionProvider.loadPaymentSession { [localizationProvider] result in
			switch result {
			case .loading: completion(.loading)
			case .success(let session): completion(.success(session))
			case .failure(let error):
				log(error)
				
				let localizer = Localizer(provider: localizationProvider)
				let localizedError = localizer.localize(error: error)
				completion(.failure(localizedError))
			}
		}
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
				let paymentError = PaymentInternalError(description: "Couldn't download a logo for a payment network %@ from %@, reason: %@", network.code, logoURL.absoluteString, error.localizedDescription)
				paymentError.log()
				completion(nil)
			}
		}
	}
}

/// Enumeration that is used for any object that can't be instantly loaded (e.g. fetched from a network)
enum Load<Success, ErrorType> where ErrorType: Error {
	case loading
	case failure(ErrorType)
	case success(Success)
}
