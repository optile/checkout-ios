import Foundation

/// Protocol responsible for sending requests, maybe faked when unit testing
public protocol RequestSender {
	func send<R>(request: R, completionHandler: @escaping ((Result<Data?, Error>) -> Void)) where R: APIRequest
}

//do {
//	let decodedResponse = try request.decodeResponse(httpResponse, data: data)
//	completionHandler(.success(decodedResponse))
//} catch {
//	completionHandler(.failure(error))
//}
