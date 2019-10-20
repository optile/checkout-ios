import XCTest
import Payment

class FakeConnection: Connection {
	func send<R>(request: R, completionHandler: @escaping ((Result<Data?, Error>) -> Void)) where R: Request {
		guard let fakeDataSource = request as? FakeDataSource else {
			let error = TestError(localizedDescription: "Request doesn't contain faked data source")
			XCTFail(error.localizedDescription)
			completionHandler(.failure(error))
			return
		}
		
		do {
			let fakeData = try fakeDataSource.makeFakeData()
			return completionHandler(.success(fakeData))
		} catch {
			XCTFail(error.localizedDescription)
			completionHandler(.failure(error))
		}
	}
}

protocol FakeDataSource {
	func makeFakeData() throws -> Data?
}
