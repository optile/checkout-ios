import XCTest
@testable import Payment

class DataDownloadProviderTests: XCTestCase {
	func testDownloadProvider() {
		let connection = MockConnection(dataSource: "test42")
		let provider = DataDownloadProvider(connection: connection)
		
		let promise = expectation(description: "NetworkDownloadProvider completion")
		provider.downloadData(from: URL.example) { result in
			switch result {
			case .success(let data):
				XCTAssertEqual(data, "test42".data(using: .isoLatin1))
			case .failure(let error):
				XCTFail(error.localizedDescription)
			}
			promise.fulfill()
		}
		
		wait(for: [promise], timeout: 1)
	}
}
