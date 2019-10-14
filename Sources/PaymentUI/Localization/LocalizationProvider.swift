import Foundation

/// Provider responsible for localizations storage and downloading
class LocalizationProvider {
	private(set) var localizations = [Dictionary<String, String>]()
	
	private let operationQueue = OperationQueue()
	
	func download(from localizationURLs: [URL], completion: @escaping ((LocalizationProvider) -> Void)) {
		let completionOperation = BlockOperation {
			completion(self)
		}
		
		for url in localizationURLs {
			let downloadOperation = makeDownloadOperation(from: url)
			completionOperation.addDependency(downloadOperation)
			operationQueue.addOperation(downloadOperation)
		}
		
		operationQueue.addOperation(completionOperation)
	}
	
	private func makeDownloadOperation(from langURL: URL) -> Operation {
		let downloadLocalizationRequest = DownloadLocalization(from: langURL)
		let downloadOperation = DownloadOperation(request: downloadLocalizationRequest)
		downloadOperation.downloadCompletionBlock = { result in
			switch result {
			case .success(let languageDictionary):
				self.localizations.append(languageDictionary)
			case .failure(let error):
				log(.error, "Error downloading localization file from '%@': %@", langURL.absoluteString, error.localizedDescription)
			}
		}
		
		return downloadOperation
	}
}
