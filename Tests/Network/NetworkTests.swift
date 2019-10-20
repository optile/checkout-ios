import XCTest
@testable import Payment

final class NetworkTests: XCTestCase {
    func testGetListResult() {
		let getListResultRequest = GetListResult(url: URL(string: "https://example.com")!)
		let fakeConnection = FakeConnection()
		
		let promise = expectation(description: "Operation completed")
		
		let sendOperation = SendRequestOperation(connection: fakeConnection, request: getListResultRequest)
		sendOperation.downloadCompletionBlock = { result in
			switch result {
			case .success(let listResult):
				XCTAssert(listResult.networks.applicable.first?.code == "VISAELECTRON")
			case .failure(let error):
				XCTFail(error.localizedDescription)
			}
			promise.fulfill()
		}
		sendOperation.start()
		
		wait(for: [promise], timeout: 1)
    }

    static var allTests = [
        ("testGetListResult", testGetListResult),
    ]
}
