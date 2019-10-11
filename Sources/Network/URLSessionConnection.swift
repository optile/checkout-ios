import Foundation
import os

class URLSessionConnection: Connection {
	let session = URLSession(configuration: URLSessionConfiguration.default)
	
	typealias RequestCompletionHandler = (Result<Data?, Error>) -> Void
	
	func send<R>(request: R, completionHandler: @escaping RequestCompletionHandler) where R : Request {
		// Build URL Request
		let urlRequest: URLRequest
		
		do {
			urlRequest = try request.build()
		} catch {
			completionHandler(.failure(error))
			return
		}
		
		// Send a network request
		let task = session.dataTask(with: urlRequest) { [handleDataTaskResponse] (data, response, error) in
			handleDataTaskResponse(data, response, error, completionHandler)
		}
		
		task.resume()
		
		if #available(OSX 10.14, iOS 12, *) {
			#if DEBUG
			let method = urlRequest.httpMethod?.uppercased() ?? ""
			os_log(.debug, "[API] >> %s %s", method, urlRequest.url!.absoluteString)
			#endif
		} else {
			// don't log anything
		}
	}
	
	// MARK: - Helper methods
	
	private func handleDataTaskResponse(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping RequestCompletionHandler) {
		// HTTP Errors
		if let error = error {
			completionHandler(.failure(error))
			return
		}

		guard let response = response else {
			completionHandler(.failure(InternalError.unexpected()))
			return
		}
		
		// We expect HTTP response
		guard let httpResponse = response as? HTTPURLResponse else {
			let error = InternalError(description: "Unexpected server response (non-http)")
			completionHandler(.failure(error))
			return
		}

		// - TODO: Read more about backend's status codes
		guard httpResponse.statusCode >= 200, httpResponse.statusCode < 400 else {
			if let data = data, let optileError = try? JSONDecoder().decode(ErrorInfo.self, from: data) {
				
				completionHandler(.failure(optileError))
			} else {
				let error = InternalError(description: "Non-OK response from a server")
				completionHandler(.failure(error))
			}
			
			return
		}
		
		completionHandler(.success(data))
	}
}
