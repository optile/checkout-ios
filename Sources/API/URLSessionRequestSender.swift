import Foundation
import os

public class URLSessionRequestSender: RequestSender {
	let endpoint: URL
	let session = URLSession(configuration: URLSessionConfiguration.default)
	
	public typealias RequestCompletionHandler = (Result<Data?, Error>) -> Void
	
	public init(endpoint: URL) {
		self.endpoint = endpoint
	}
	
	public func send<R>(request: R, completionHandler: @escaping RequestCompletionHandler) where R : APIRequest {
		// Build URL Request
		let resultURLRequest = buildURLRequest(from: request)
		let urlRequest: URLRequest
		
		switch resultURLRequest {
		case .failure(let error):
			completionHandler(.failure(error))
			return
		case .success(let request):
			urlRequest = request
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
			completionHandler(.failure(APIError.unexpected()))
			return
		}
		
		// We expect HTTP response
		guard let httpResponse = response as? HTTPURLResponse else {
			let error = APIError(description: "Unexpected server response (non-http)")
			completionHandler(.failure(error))
			return
		}

		// - TODO: Read more about backend's status codes
		guard httpResponse.statusCode >= 200, httpResponse.statusCode < 400 else {
			if let data = data, let optileError = try? JSONDecoder().decode(OptileError.self, from: data) {
				
				completionHandler(.failure(optileError))
			} else {
				let error = APIError(description: "Non-OK response from a server")
				completionHandler(.failure(error))
			}
			
			return
		}
		
		completionHandler(.success(data))
	}
	
	/// Construct a full URL for request
	private func buildURLRequest<R>(from request: R) -> Result<URLRequest, Error> where R: APIRequest {
		var components = URLComponents()
		components.scheme = endpoint.scheme
		components.host = endpoint.host
		components.path = endpoint.path + "/" + request.path
		components.queryItems = request.queryItems
		
		guard let url = components.url else {
			let error = APIError(description: "Internal error, unable to make API request URL")
			return .failure(error)
		}
		
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = request.method.rawValue
		do {
			urlRequest.httpBody = try request.encodeBody()
			return .success(urlRequest)
		} catch {
			return .failure(error)
		}
	}
}
