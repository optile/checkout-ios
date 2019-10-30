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
	
	func loadPaymentSession(completion: @escaping ((Load<PaymentSession>) -> Void)) {
		paymentSessionProvider.loadPaymentSession { [localize] result in
			// TODO: Return `LocalizedError`, not `Error`
			switch result {
			case .failure(let error):
				let localizedError = localize(error)
				completion(.failure(localizedError))
			default: completion(result)
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
				log(.error, "Couldn't download a logo for a payment network %@ from %@, reason: %@", network.code, logoURL.absoluteString, error.localizedDescription)
				completion(nil)
			}
		}
	}
	
	private func localize(error: Error) -> LocalizedError {
		let localizer = Localizer(provider: localizationProvider)
		
		switch error {
		case let localized as LocalizedError: return localized
		case let localizable as LocalizableError:
			let localized = localizer.localize(model: localizable)
			return localized.transformToPaymentError()
		default:
			var defaultError = LocalizableError(localizationKey: .errorDefault)
			defaultError.underlyingError = error
			localizer.localize(model: &defaultError)
			return defaultError.transformToPaymentError()
		}
	}
}

extension LocalizableError {
	func transformToPaymentError() -> PaymentError {
		return .init(localizedDescription: self.localizedDescription, isRetryable: self.isRetryable, underlyingError: self.underlyingError)
	}
}
