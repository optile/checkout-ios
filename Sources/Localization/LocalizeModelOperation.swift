import Foundation


class LocalizeModelOperation<Model>: AsynchronousOperation where Model: Localizable {
	var sharedLocalizations: [Dictionary<String, String>] = []
	
	let modelToLocalize: Model
		
	private(set) var localizedModel: Model?

	init(_ model: Model) {
		self.modelToLocalize = model
	}
	
	override func main() {
		if let localizationFileURL = modelToLocalize.localeURL {
			let downloadLocalizationRequest = DownloadLocalization(from: localizationFileURL)
			let sendRequestOperation = SendRequestOperation(request: downloadLocalizationRequest)
			sendRequestOperation.downloadCompletionBlock = {
				self.downloadAdditionalLocalizationHandler(model: self.modelToLocalize, otherTranslations: self.sharedLocalizations, downloadLocalizationResult: $0)
			}
			sendRequestOperation.start()
		} else {
			let localizedModel = localize(model: modelToLocalize, using: sharedLocalizations)
			
			finish(with: localizedModel)
		}
	}
	
	private func finish(with model: Model) {
		self.localizedModel = model
		finish()
	}
	
	private func downloadAdditionalLocalizationHandler(model: Model, otherTranslations: [Dictionary<String, String>], downloadLocalizationResult: Result<Dictionary<String, String>, Error>) {
		let localizedModel: Model
		
		switch downloadLocalizationResult {
		case .success(let specificTranslation):
			var allTranslations = otherTranslations
			allTranslations += [specificTranslation]
			localizedModel = localize(model: model, using: allTranslations)
		case .failure(let error):
			log(.error, "Downloading specific localization failed with error: %@, using only shared localizations", error.localizedDescription)
			localizedModel = localize(model: model, using: otherTranslations)
		}
		
		finish(with: localizedModel)
	}
	
	private func localize(model: Model, using localizations: [Dictionary<String, String>]) -> Model {
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
