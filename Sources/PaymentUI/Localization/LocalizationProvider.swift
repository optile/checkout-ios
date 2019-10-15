import Foundation

/// Provider responsible for localizations storage and downloading
class LocalizationProvider {
	private let combinedLocalizations: [Dictionary<String, String>]

	init(sharedTranslation: Dictionary<String, String>?) {
		var localizations = [Dictionary<String, String>]()
		
		if let sharedTranslation = sharedTranslation {
			localizations.append(sharedTranslation)
		}
		localizations.append(LocalizationProvider.localTranslations)
		
		self.combinedLocalizations = localizations
	}
	
	func add(localizationURL: URL, completion: @escaping (([Dictionary<String, String>]) -> Void)) {
		LocalizationProvider.download(from: localizationURL) { [combinedLocalizations] result in
			switch result {
			case .success(let localization):
				var localizations = combinedLocalizations
				localizations.append(localization)
				completion(localizations)
			case .failure(let error):
				log(.error, "Failed to download applicable network's localization: %@", error.localizedDescription)
				completion(combinedLocalizations)
			}
		}
	}
	
	// MARK: - Static methods
	
	static func download(from localizationURL: URL, completion: @escaping ((Result<Dictionary<String, String>, Error>) -> Void)) {
		let downloadLocalizationRequest = DownloadLocalization(from: localizationURL)
		let downloadOperation = DownloadOperation(request: downloadLocalizationRequest)
		downloadOperation.downloadCompletionBlock = completion
		downloadOperation.start() // we could start without async because operation is already asynchronous
	}
	
	static func prepare(anyApplicableNetworkLangURL: URL, completion: @escaping ((LocalizationProvider) -> Void)) {
		let paymentPageLocalizationURL: URL
		
		do {
			paymentPageLocalizationURL = try anyApplicableNetworkLangURL.paymentPageLocalizationURL()
		} catch {
			log(.error, "Failed to make a correct payment page url: %@", error.localizedDescription)
			completion(LocalizationProvider(sharedTranslation: nil))
			return
		}
		
		download(from: paymentPageLocalizationURL) { result in
			let provider: LocalizationProvider
			
			switch result {
			case .success(let translation):
				provider = .init(sharedTranslation: translation)
			case .failure(let error):
				log(.error, "Failed to download shared localization: %@", error.localizedDescription)
				provider = .init(sharedTranslation: nil)
			}
			
			completion(provider)
		}
	}
	

}

private extension URL {
	/// Transform any applicable network url to paymentpage localization url.
	///
	/// Example:
	/// - From: `https://resources.sandbox.oscato.com/resource/lang/VASILY_DEMO/en_US/VISAELECTRON.properties`
	/// - To: `https://resources.sandbox.oscato.com/resource/lang/VASILY_DEMO/en_US/paymentpage.properties`
	func paymentPageLocalizationURL() throws -> URL {
		guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
			let error = NetworkInternalError(description: "Incorrect shared translation URL: " + self.absoluteString)
			throw error
		}
		
		guard let lastPathComponent = components.path.components(separatedBy: "/").last else {
			let error = NetworkInternalError(description: "Unable to find the last path component in url: " + self.absoluteString)
			throw error
		}
		
		var updatedComponents = components
		updatedComponents.path = components.path.replacingOccurrences(of: lastPathComponent, with: "paymentpage")
		
		guard let paymentPageURL = updatedComponents.url else {
			let error = NetworkInternalError(description: "Unable for form a url from URLComponents: \(updatedComponents)")
			throw error
		}
		
		return paymentPageURL
	}
}
