import XCTest
@testable import Payment

class NetworkDownloadProviderTests: XCTestCase {
	func testDownloadProvider() {
		let connection = MockConnection(dataSource: "test42")
		let provider = NetworkDownloadProvider(connection: connection)
		
		let promise = expectation(description: "NetworkDownloadProvider completion")
		provider.downloadData(from: URL.example) { result in
			switch result {
			case .success(let data):
				XCTAssertEqual(data, try! connection.dataSource.fakeData.get())
			case .failure(let error):
				XCTFail(error.localizedDescription)
			}
			promise.fulfill()
		}
		
		wait(for: [promise], timeout: 1)
	}
}
