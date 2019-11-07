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
	
	func localize(error: Error, fallback: LocalTranslation = .errorDefault) -> String {
		// Localizable Error
		if let localizable = error as? LocalizableError {
			let localized = localize(model: localizable)
			return localized.localizedDescription
		}
		
		// Connection errors, return Apple's localized description for connection's errors and make it retryable
		let nsError = error as NSError
		
		let allowedCodes: [URLError.Code] = [.notConnectedToInternet, .dataNotAllowed]
		let allowedCodesNumber = allowedCodes.map { $0.rawValue }
		if nsError.domain == NSURLErrorDomain, allowedCodesNumber.contains(nsError.code) {
			return nsError.localizedDescription
		}
		
		// Throw a default error
		let localizableError = LocalizableError(localizationKey: fallback)
		return localize(model: localizableError).localizedDescription
	}
	
	func localize<Model>(model: inout Model, using translations: [Dictionary<String, String>]) where Model: Localizable {
		for localizationKey in model.localizableFields {
			let localized: String
			
			if let translation = findTranslation(forKey: localizationKey.key, in: translations) {
				 localized = translation
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

