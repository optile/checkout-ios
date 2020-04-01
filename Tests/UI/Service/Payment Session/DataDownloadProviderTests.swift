import XCTest
@testable import Optile

class DataDownloadProviderTests: XCTestCase {
    func testDownloadProvider() {
        let connection = MockConnection(dataSource: "test42")
        let provider = DataDownloadProvider(connection: connection)

        let model = MockModel()
        let promise = expectation(description: "NetworkDownloadProvider completion")
        provider.downloadData(for: [model]) {
            guard case let .loaded(result) = model.loadable else {
                XCTFail("Unexpected result for mock model")
                promise.fulfill()
                return
            }
            
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

private class MockModel: ContainsLoadableData {
    var loadable: Loadable<Data>? = .notLoaded(URL.example)
}
