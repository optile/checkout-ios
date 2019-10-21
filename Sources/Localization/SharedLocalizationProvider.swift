import Foundation

class SharedLocalizationProvider {
	typealias Localization = Dictionary<String, String>
	
	let connection: Connection
	let localTranslations: Dictionary<String, String>
	
	init(connection: Connection, localTranslations: Dictionary<String, String>) {
		self.connection = connection
		self.localTranslations = localTranslations
	}
	
	convenience init(connection: Connection) {
		self.init(connection: connection, localTranslations: SharedLocalizationProvider.localTranslations)
	}
	
	func download(using url: URL, completion: @escaping ((Result<[Dictionary<String, String>], Error>) -> Void)) {
		let paymentPageURL: URL
		
		do {
			paymentPageURL = try url.transformToPaymentPageLocalizationURL()
		} catch {
			completion(.failure(error))
			return
		}
		
		let downloadLocalizationRequest = DownloadLocalization(from: paymentPageURL)
		let sendRequestOperation = SendRequestOperation(connection: connection, request: downloadLocalizationRequest)
		sendRequestOperation.downloadCompletionBlock = { [localTranslations] result in
			switch result {
			case .success(let translation):
				let allLocalizations = [translation, localTranslations]
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
	func transformToPaymentPageLocalizationURL() throws -> URL {
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
