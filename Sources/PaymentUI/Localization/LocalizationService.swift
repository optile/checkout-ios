import Foundation

/// Service responsible for translation.
class LocalizationService {
	let provider: LocalizationProvider
	
	init(provider: LocalizationProvider) {
		self.provider = provider
	}
	
	func localize<Model>(model: Model, completion: @escaping ((Model) -> Void)) where Model: Localizable {
		if let localeURL = model.localeURL {
			// Model has localization URL, download and localize using it and other localization dictionaries
			provider.getLocalizations(additionalLocalizationURL: localeURL) { localizations in
				let localizedModel = self.localize(model: model, using: localizations)
				completion(localizedModel)
			}
		} else {
			// Model doesn't have a localization URL, fallback using shared and local translations
			let localizedModel = localize(model: model, using: provider.combinedLocalizations)
			completion(localizedModel)
		}
	}
	
	func localize<Model>(models: [Model], completion: @escaping (([Model]) -> Void)) where Model: Localizable {
		var localizedModels = [Model]()
		for model in models {
			localize(model: model) { localizedModel in
				localizedModels.append(localizedModel)
				// TODO: Change to Operation to limit concurrent connections count
				if localizedModels.count == models.count {
					completion(localizedModels)
				}
			}
		}
	}
	
	// MARK: - Private methods
	
	private func localize<Model>(model: Model, using localizations: [Dictionary<String, String>]) -> Model where Model: Localizable {
		var localizedModel = model
		
		for localizationKey in localizedModel.localizableFields {
			guard let translation = findTranslation(forKey: localizationKey.key, in: localizations) else { continue }
			localizedModel[keyPath: localizationKey.field] = translation
		}
		
		return localizedModel
	}
	
	private func findTranslation(forKey key: String, in localizations: [Dictionary<String, String>]) -> String? {
		for localization in localizations {
			guard let translation = localization[key] else { continue }
			return translation
		}
		
		return nil
	}
}

