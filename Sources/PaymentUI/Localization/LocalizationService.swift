import Foundation

/// Service responsible for translation. Localization dictionaries must be passed
class LocalizationService {
	var defaultLocalizations: [Dictionary<String, String>]
	
	init(defaultLocalizations: [Dictionary<String, String>]) {
		self.defaultLocalizations = defaultLocalizations
	}
	
	func localize<Model>(model: inout Model, using priorityLocalization: Dictionary<String, String>) where Model: Localizable {
		var localizations = defaultLocalizations
		localizations.insert(priorityLocalization, at: 0)
		
		for localizationKey in model.localizableFields {
			guard let translation = findTranslation(forKey: localizationKey.key, in: localizations) else { continue }
			model[keyPath: localizationKey.field] = translation
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

