import Foundation

class SharedTranslationProvider: TranslationProvider {
	private let localTranslations: Dictionary<String, String>
	private var remoteSharedTranslations: Dictionary<String, String> = [:]
	
	var translations: [Dictionary<String, String>] {
		return [remoteSharedTranslations, localTranslations]
	}
	
	init(localTranslations: Dictionary<String, String> = LocalTranslation.allCasesAsDictionary) {
		self.localTranslations = localTranslations
	}
	
	func download(from url: URL, using connection: Connection, completion: @escaping ((Error?) -> Void)) {
		let paymentPageURL: URL
		
		do {
			paymentPageURL = try url.transformToPaymentPageLocalizationURL()
		} catch {
			completion(error)
			return
		}
		
		let downloadLocalizationRequest = DownloadLocalization(from: paymentPageURL)
		let sendRequestOperation = SendRequestOperation(connection: connection, request: downloadLocalizationRequest)
		sendRequestOperation.downloadCompletionBlock = { result in
			switch result {
			case .success(let translation):
				self.remoteSharedTranslations = translation
				completion(nil)
			case .failure(let error):
				completion(error)
			}
		}
		
		sendRequestOperation.start()
	}
}

private extension URL {
	/// Transform any applicable network url to paymentpage localization url.
	///
	/// Example:
	/// - From: `https://resources.sandbox.oscato.com/resource/lang/VASILY_DEMO/en_US/VISAELECTRON.properties`
	/// - To: `https://resources.sandbox.oscato.com/resource/lang/VASILY_DEMO/en_US/paymentpage.properties`
	func transformToPaymentPageLocalizationURL() throws -> URL {
		guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
			let error = InternalError(description: "Incorrect shared translation URL: %@", self.absoluteString)
			throw error
		}
		
		guard let lastPathComponent = components.path.components(separatedBy: "/").last else {
			let error = InternalError(description: "Unable to find the last path component in url %@", self.absoluteString)
			throw error
		}
		
		var updatedComponents = components
		updatedComponents.path = components.path.replacingOccurrences(of: lastPathComponent, with: "paymentpage.properties")
		
		guard let paymentPageURL = updatedComponents.url else {
			let error = InternalError(description: "Unable for form a url from URLComponents: %@", "\(updatedComponents)")
			throw error
		}
		
		return paymentPageURL
	}
}

private extension LocalTranslation {
	static var allCasesAsDictionary: Dictionary<String, String> {
		var dictionary = Dictionary<String, String>()
		
		for translation in LocalTranslation.allCases {
			dictionary[translation.rawValue] = translation.localizedString
		}
		
		return dictionary
	}
}
