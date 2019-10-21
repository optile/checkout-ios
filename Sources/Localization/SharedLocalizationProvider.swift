import Foundation

class SharedLocalizationProvider {
	typealias Localization = Dictionary<String, String>
	
	let connection: Connection
	
	init(connection: Connection) {
		self.connection = connection
	}
	
	convenience init() {
		self.init(connection: URLSessionConnection())
	}
	
	func download(using url: URL, completion: @escaping ((Result<[Dictionary<String, String>], Error>) -> Void)) {
		let downloadLocalizationRequest = DownloadLocalization(from: url)
		let sendRequestOperation = SendRequestOperation(request: downloadLocalizationRequest)
		sendRequestOperation.downloadCompletionBlock = { result in
			switch result {
			case .success(let translation):
				let allLocalizations = [translation, SharedLocalizationProvider.localTranslations]
				completion(.success(allLocalizations))
			case .failure(let error):
				completion(.failure(error))
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
	func paymentPageLocalizationURL() throws -> URL {
		guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
			let error = PaymentInternalError(description: "Incorrect shared translation URL: " + self.absoluteString)
			throw error
		}
		
		guard let lastPathComponent = components.path.components(separatedBy: "/").last else {
			let error = PaymentInternalError(description: "Unable to find the last path component in url: " + self.absoluteString)
			throw error
		}
		
		var updatedComponents = components
		updatedComponents.path = components.path.replacingOccurrences(of: lastPathComponent, with: "paymentpage.properties")
		
		guard let paymentPageURL = updatedComponents.url else {
			let error = PaymentInternalError(description: "Unable for form a url from URLComponents: \(updatedComponents)")
			throw error
		}
		
		return paymentPageURL
	}
}
