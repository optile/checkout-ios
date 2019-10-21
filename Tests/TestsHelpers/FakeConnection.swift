import Foundation
import Payment

protocol FakeConnection: Connection {
	func fakeData(for request: URLRequest) -> Result<Data?, Error>
}

extension FakeConnection {
	func send(request: URLRequest, completionHandler: @escaping ((Result<Data?, Error>) -> Void)) {
		completionHandler(fakeData(for: request))
	}
	
	func cancel() {}
}
