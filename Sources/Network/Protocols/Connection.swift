import Foundation

/// Protocol responsible for sending requests, maybe faked when unit testing
public protocol Connection {
	func send(request: URLRequest, completionHandler: @escaping ((Result<Data?, Error>) -> Void))
	func cancel()
}
