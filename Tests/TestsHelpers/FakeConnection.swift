import Foundation
import Payment

protocol FakeConnection: Connection {
	func fakeData<R>(for request: R) -> Result<Data?, Error> where R: Request
}

extension FakeConnection {
	func send<R>(request: R, completionHandler: @escaping ((Result<Data?, Error>) -> Void)) where R: Request {
		completionHandler(fakeData(for: request))
	}
}
