import Foundation

class LocalizeModelOperation<Model>: AsynchronousOperation where Model: Localizable {
	let additionalProvider: LocalizationsProvider
	let modelToLocalize: Model
	let connection: Connection
	let localeURL: URL?
	
	private(set) var localizedModel: Model?
	private(set) var remoteLocalizationError: Error?
	
	var localizationCompletionBlock: ((Model) -> Void)?

	init(_ model: Model, downloadFrom url: URL?, using connection: Connection, additionalProvider: LocalizationsProvider) {
		self.modelToLocalize = model
		self.connection = connection
		self.additionalProvider = additionalProvider
		self.localeURL = url
	}
	
	override func main() {
		if let localizationFileURL = localeURL {
			let provider = RemoteLocalizationsProvider(otherTranslations: additionalProvider.translations)
			provider.downloadTranslation(from: localizationFileURL, using: connection) { [modelToLocalize] in
				let localizer = Localizer(provider: provider)
				let localizedModel = localizer.localize(model: modelToLocalize)

				self.finish(with: localizedModel)
			}
		} else {
			let localizer = Localizer(provider: additionalProvider)
			let localizedModel = localizer.localize(model: modelToLocalize)

			finish(with: localizedModel)
		}
	}
	
	private func finish(with model: Model) {
		self.localizedModel = model
		localizationCompletionBlock?(model)
		finish()
	}
}

private class RemoteLocalizationsProvider: LocalizationsProvider {
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
	
	func downloadTranslation(from url: URL, using connection: Connection, completion: @escaping (() -> Void)) {
		let downloadLocalizationRequest = DownloadLocalization(from: url)
		let sendRequestOperation = SendRequestOperation(connection: connection, request: downloadLocalizationRequest)
		sendRequestOperation.downloadCompletionBlock = { result in
			switch result {
			case .success(let remoteTranslation): self.remoteTranslation = remoteTranslation
			case .failure(let error):
				log(.error, "Downloading specific localization failed with error: %@", error.localizedDescription)
			}
			
			completion()
		}
		sendRequestOperation.start()
	}
}
