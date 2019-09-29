import Foundation
import os

public class APIClient {
	public let requestSender: RequestSender

	public init(requestSender: RequestSender) {
		self.requestSender = requestSender
	}
	
	public func send<R>(request: R, completionHandler: @escaping ((Result<R.Response, Error>) -> Void)) where R: APIRequest {
		requestSender.send(request: request) { result in
			switch result {
			case .success(let data):
				do {
					let decodedResponse = try request.decodeResponse(with: data)
					completionHandler(.success(decodedResponse))
				} catch {
					completionHandler(.failure(error))
				}
			case .failure(let error):
				completionHandler(.failure(error))
			}
		}
	}
}
