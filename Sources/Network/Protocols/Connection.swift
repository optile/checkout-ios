import Foundation

/// Protocol responsible for sending requests, maybe faked when unit testing
public protocol Connection {
	func send<R>(request: R, completionHandler: @escaping ((Result<Data?, Error>) -> Void)) where R: Request
}
