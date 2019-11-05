import XCTest
@testable import Payment

class LocalizeModelOperationTests: XCTestCase {
	private let remoteTranslationString = "some.key=remote\n"
	private let provider = MockTranslationProvider()
	
	func testHasRemote() {
		let expectation = MockModel(testValue: "remote", otherValue: "local2", notFoundKey: "")
		invokeLocalizeOperation(model: MockModel(), remote: remoteTranslationString, expected: expectation, isErrorExpected: false)
	}
	
	// Should fallback to shared and local, error will be logged
	func testFailedRemote() {
		let error = TestError(description: "No connection")
		let expectation = MockModel(testValue: "shared", otherValue: "local2", notFoundKey: "")
		invokeLocalizeOperation(model: MockModel(), remote: error, expected: expectation, isErrorExpected: true)
	}
	
	// Should fallback to shared and local, no errors will be logged
	func testNoRemote() {
		let model = MockModel()
		let expectation = MockModel(testValue: "shared", otherValue: "local2", notFoundKey: "")
		invokeLocalizeOperation(model: model, url: nil, remote: remoteTranslationString, expected: expectation, isErrorExpected: false)
	}
	
	fileprivate func invokeLocalizeOperation(model: MockModel, url: URL? = URL.example, remote: MockDataSource, expected: MockModel, isErrorExpected: Bool) {
		let connection = MockConnection(dataSource: remote)

		let promise = expectation(description: "LocalizeModelOperation completed")
		let operation = LocalizeModelOperation(model, downloadFrom: url, using: connection, additionalProvider: provider)
		operation.completionBlock = { promise.fulfill() }
		operation.start()
		wait(for: [promise], timeout: 1)

		XCTAssertEqual(connection.requestedURL, url)
		XCTAssertNotNil(operation.localizationResult, "Model wasn't localized")

		if isErrorExpected {
			switch operation.localizationResult {
			case .failure: return
			default:
				XCTFail("Localization result doesn't contain an error")
				return
			}
		}
		
		// If error is not expected
		
		guard case let .success(localizedModel) = operation.localizationResult else {
			XCTFail("Localization result doesn't contain localized model")
			return
		}

		XCTAssertEqual(localizedModel.testValue, expected.testValue)
		XCTAssertEqual(localizedModel.otherValue, expected.otherValue)
		XCTAssertEqual(localizedModel.notFoundKey, expected.notFoundKey)
	}
}

private struct MockModel: Localizable {
	var testValue: String
	var otherValue: String
	var notFoundKey: String
	
	var localizableFields: [LocalizationKey<MockModel>] = [
		.init(\.testValue, key: "some.key"),
		.init(\.otherValue, key: "some2.key"),
		.init(\.notFoundKey, key: "no.key")
	]
	
	init(testValue: String = "original", otherValue: String = "original2", notFoundKey: String = "original") {
		self.testValue = testValue
		self.otherValue = otherValue
		self.notFoundKey = notFoundKey
	}
}

private class MockTranslationProvider: TranslationProvider {
	let sharedTranslation = ["some.key": "shared"]
	let localTranslation = ["some.key": "local", "some2.key": "local2"]
	
	var translations: [Dictionary<String, String>] { [sharedTranslation, localTranslation] }
}
