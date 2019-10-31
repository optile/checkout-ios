import Foundation

class Localizer {
	let provider: TranslationProvider
	
	init(provider: TranslationProvider) {
		self.provider = provider
	}
	
	func localize<Model>(model: Model) -> Model where Model: Localizable {
		var localizedModel = model
		localize(model: &localizedModel)
		return localizedModel
	}
	
	func localize<Model>(model: inout Model) where Model: Localizable {
		localize(model: &model, using: provider.translations)
	}
	
	func localize(error: Error, fallback: LocalTranslation = .errorDefault) -> PaymentError {
		// Localizable Error
		if let localizable = error as? LocalizableError {
			let localized = localize(model: localizable)
			return PaymentError(localizedDescription: localized.localizedDescription, isRetryable: false, underlyingError: localized.underlyingError)
		}
		
		// Connection errors, return Apple's localized description for connection's errors and make it retryable
		let nsError = error as NSError
		
		let allowedCodes: [URLError.Code] = [.notConnectedToInternet, .dataNotAllowed]
		let allowedCodesNumber = allowedCodes.map { $0.rawValue }
		if nsError.domain == NSURLErrorDomain, allowedCodesNumber.contains(nsError.code) {
			return PaymentError(localizedDescription: nsError.localizedDescription, isRetryable: true, underlyingError: error)
		}
		
		// Throw a default error
		var localizableError = LocalizableError(localizationKey: fallback)
		localize(model: &localizableError)
		
		return PaymentError(localizedDescription: localizableError.localizedDescription, isRetryable: false, underlyingError: error)
	}
	
	func localize<Model>(model: inout Model, using translations: [Dictionary<String, String>]) where Model: Localizable {
		for localizationKey in model.localizableFields {
			let localized: String
			
			if let translation = findTranslation(forKey: localizationKey.key, in: translations) {
				 localized = translation
			} else if let fallbackKey = localizationKey.fallbackKey, let fallbackTranslation = findTranslation(forKey: fallbackKey, in: translations) {
				localized = fallbackTranslation
			} else {
				// @siebe approach to nullify string that has not localization
				localized = String()
			}
			
			model[keyPath: localizationKey.field] = localized
		}
	}
	
	private func findTranslation(forKey key: String, in localizations: [Dictionary<String, String>]) -> String? {
		for localization in localizations {
			guard let translation = localization[key] else { continue }
			return translation
		}
		
		return nil
	}
}

