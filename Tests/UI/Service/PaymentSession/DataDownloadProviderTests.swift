// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import XCTest
@testable import PayoneerCheckout

class DataDownloadProviderTests: XCTestCase {
    @available(iOS 13.0, *)
    func testDownloadProvider() {
        let bundle = Bundle(for: DataDownloadProvider.self)
        let image = UIImage(named: "visa", in: bundle, compatibleWith: nil)!
        let imageData = image.pngData()!

        let connection = MockConnection(dataSource: imageData)
        let provider = DataDownloadProvider(connection: connection)

        let model = MockModel()
        let promise = expectation(description: "NetworkDownloadProvider completion")
        provider.downloadImages(for: [model]) {
            guard case let .loaded(result) = model.loadable else {
                XCTFail("Unexpected result for mock model")
                promise.fulfill()
                return
            }

            switch result {
            case .success:
                // Image has been downloaded
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            promise.fulfill()
        }

        wait(for: [promise], timeout: 1)
    }
}

private class MockModel: ContainsLoadableImage {
    var loadable: Loadable<UIImage>? = .notLoaded(URL.example)
}
