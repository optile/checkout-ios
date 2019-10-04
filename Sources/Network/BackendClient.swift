import Foundation
import os

public class BackendClient {
	let connection: Connection

	init(connection: Connection) {
		self.connection = connection
	}
	
	public convenience init() {
		let connection = URLSessionConnection()
		self.init(connection: connection)
	}
	
	public func send<R>(request: R, completionHandler: @escaping ((Result<R.Response, Error>) -> Void)) where R: Request {
		connection.send(request: request) { result in
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
