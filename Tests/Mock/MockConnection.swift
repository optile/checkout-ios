import Foundation
import Payment

class MockConnection: Connection {
	private(set) var requestedURL: URL?
	let dataSource: MockDataSource
	
	init(dataSource: MockDataSource) {
		self.dataSource = dataSource
	}
	
	func send(request: URLRequest, completionHandler: @escaping ((Result<Data?, Error>) -> Void)) {
		self.requestedURL = request.url!
		completionHandler(dataSource.fakeData(for: request))
	}
	
	func cancel() {}
}
