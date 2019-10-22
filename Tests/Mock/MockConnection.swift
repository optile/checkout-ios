import Foundation
import Payment

class MockConnection: Connection {
	private(set) var requestedURL: URL?
	let dataSource: MockDataSource
	
	init(dataSource: MockDataSource) {
		self.dataSource = dataSource
	}
	
	func fakeData(for request: URLRequest) -> Result<Data?, Error> {
		return dataSource.fakeData
	}
	
	func send(request: URLRequest, completionHandler: @escaping ((Result<Data?, Error>) -> Void)) {
		self.requestedURL = request.url!
		completionHandler(fakeData(for: request))
	}
	
	func cancel() {}
}
