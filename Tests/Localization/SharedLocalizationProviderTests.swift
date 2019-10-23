import XCTest
@testable import Payment

class SharedLocalizationProviderTests: XCTestCase {
	func testSuccessDownload() {
		let localTranslation = ["test1": "value1", "test2": "value2"]
		
		let connection = MockConnection(dataSource: MockFactory.Localization.paymentPage)
		let provider = SharedLocalizationProvider(connection: connection, localTranslations: localTranslation)
		let promise = expectation(description: "SharedLocalizationProvider response")
		let paymentNetworkLangURL = URL(string: "https://resources.sandbox.oscato.com/resource/lang/VASILY_DEMO/en_US/VISAELECTRON.properties")!
		provider.download(using: paymentNetworkLangURL) { result in
			let dictionaries: [Dictionary<String, String>]
			
			switch result {
			case .success(let resultDictionaries): dictionaries = resultDictionaries
			case .failure(let error):
				XCTFail(error.localizedDescription)
				return
			}
			
			let attachment = XCTAttachment(plistObject: dictionaries)
			self.add(attachment)
			
			XCTAssertEqual(dictionaries.count, 2)
			
			XCTAssertEqual(dictionaries[0]["deleteRegistrationTooltip"], "Delete payment account")
			XCTAssertEqual(dictionaries[0].count, 54)
			
			XCTAssertEqual(dictionaries[1], localTranslation)
			
			promise.fulfill()
		}
		wait(for: [promise], timeout: 1)
				
		XCTAssertEqual(
			connection.requestedURL,
			URL(string: "https://resources.sandbox.oscato.com/resource/lang/VASILY_DEMO/en_US/paymentpage.properties")!
		)
	}
	
	func testFailedDownload() {
		let testError = TestError(errorDescription: "Test error")
		let connection = MockConnection(dataSource: testError)
		let provider = SharedLocalizationProvider(connection: connection)
		
		let promise = expectation(description: "SharedLocalizationProvider response")
		
		provider.download(using: URL.example) { result in
			switch result {
			case .failure(let error):
				XCTAssertEqual(error.localizedDescription, testError.localizedDescription)
			case .success:
				XCTFail("Expected failure because framework is not intended to work without downloaded shared dictionary")
			}

			promise.fulfill()
		}
		wait(for: [promise], timeout: 1)
	}
}
