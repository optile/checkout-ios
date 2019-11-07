import Foundation

class LocalizeModelOperation<Model>: AsynchronousOperation where Model: Localizable {
	let additionalProvider: TranslationProvider
	let modelToLocalize: Model
	let connection: Connection
	let localeURL: URL?
	
	private(set) var localizationResult: Result<Model, Error>?
	
	init(_ model: Model, downloadFrom url: URL?, using connection: Connection, additionalProvider: TranslationProvider) {
		self.modelToLocalize = model
		self.connection = connection
		self.additionalProvider = additionalProvider
		self.localeURL = url
	}
	
	override func main() {
		if let localizationFileURL = localeURL {
			let provider = DownloadableTranslationProvider(otherTranslations: additionalProvider.translations)
			provider.downloadTranslation(from: localizationFileURL, using: connection) { [modelToLocalize] error in
				if let error = error {
					self.finish(with: .failure(error))
					return
				}
				
				let localizer = Localizer(provider: provider)
				let localizedModel = localizer.localize(model: modelToLocalize)
				
				self.finish(with: .success(localizedModel))
			}
		} else {
			let localizer = Localizer(provider: additionalProvider)
			let localizedModel = localizer.localize(model: modelToLocalize)

			finish(with: .success(localizedModel))
		}
	}
	
	private func finish(with result: Result<Model, Error>) {
		self.localizationResult = result
		finish()
	}
}

private class DownloadableTranslationProvider: TranslationProvider {
	var translations: [Dictionary<String, String>] {
		var resultingArray = [remoteTranslation]
		resultingArray.append(contentsOf: otherTranslations)
		return resultingArray
	}
	
	private let otherTranslations: [Dictionary<String, String>]
	private var remoteTranslation = Dictionary<String, String>()
	
	init(otherTranslations: [Dictionary<String, String>]) {
		self.otherTranslations = otherTranslations
	}
	
	func downloadTranslation(from url: URL, using connection: Connection, completion: @escaping ((Error?) -> Void)) {
		let downloadLocalizationRequest = DownloadLocalization(from: url)
		let sendRequestOperation = SendRequestOperation(connection: connection, request: downloadLocalizationRequest)
		sendRequestOperation.downloadCompletionBlock = { result in
			switch result {
			case .success(let remoteTranslation):
				self.remoteTranslation = remoteTranslation
				completion(nil)
			case .failure(let error):
				let paymentError = InternalError(description: "Downloading specific localization failed with error %@", objects: error)
				completion(paymentError)
			}
		}
		sendRequestOperation.start()
	}
}
