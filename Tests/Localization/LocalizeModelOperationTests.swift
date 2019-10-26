import XCTest
@testable import Payment

class LocalizeModelOperationTests: XCTestCase {
	private let remoteTranslationString = "some.key=remote\n"
	private let sharedTranslation = ["some.key": "shared"]
	private let localTranslation = ["some.key": "local", "some2.key": "local2"]
	
	func testHasRemote() {
		let expectation = MockModel(testValue: "remote", otherValue: "local2", notFoundKey: "")
		invokeLocalizeOperation(model: MockModel(), remote: remoteTranslationString, expected: expectation, isErrorExpected: false)
	}
	
	// Should fallback to shared and local, error will be logged
	func testFailedRemote() {
		let error = TestError(errorDescription: "No connection")
		let expectation = MockModel(testValue: "shared", otherValue: "local2", notFoundKey: "")
		invokeLocalizeOperation(model: MockModel(), remote: error, expected: expectation, isErrorExpected: true)
	}
	
	// Should fallback to shared and local, no errors will be logged
	func testNoRemote() {
		let model = MockModel(localeURL: nil)
		let expectation = MockModel(testValue: "shared", otherValue: "local2", notFoundKey: "")
		invokeLocalizeOperation(model: model, remote: remoteTranslationString, expected: expectation, isErrorExpected: false)
	}
	
	fileprivate func invokeLocalizeOperation(model: MockModel, remote: MockDataSource, expected: MockModel, isErrorExpected: Bool) {
		let connection = MockConnection(dataSource: remote)
		
		let operation = LocalizeOperation(model, use: connection)
		operation.sharedLocalizations = [sharedTranslation, localTranslation]
		let promise = expectation(description: "LocalizeModelOperation completed")
		operation.completionBlock = { promise.fulfill() }
		operation.start()
		wait(for: [promise], timeout: 1)
		
		XCTAssertNotNil(operation.localizedModel, "Model wasn't localized")

		XCTAssertEqual(operation.localizedModel!.testValue, expected.testValue)
		XCTAssertEqual(operation.localizedModel!.otherValue, expected.otherValue)
		XCTAssertEqual(operation.localizedModel!.notFoundKey, expected.notFoundKey)

		XCTAssertEqual(connection.requestedURL, model.localeURL)
		
		if isErrorExpected {
			XCTAssertNotNil(operation.remoteLocalizationError)
		} else {
			XCTAssertNil(operation.remoteLocalizationError)
		}
	}
	

}

private struct MockModel: Localizable {
	let localeURL: URL?
	var testValue: String
	var otherValue: String
	var notFoundKey: String
	
	var localizableFields: [LocalizationKey<MockModel>] = [
		.init(\.testValue, key: "some.key"),
		.init(\.otherValue, key: "some2.key"),
		.init(\.notFoundKey, key: "no.key")
	]
	
	init(testValue: String = "original", localeURL: URL? = URL.example, otherValue: String = "original2", notFoundKey: String = "original") {
		self.testValue = testValue
		self.localeURL = localeURL
		self.otherValue = otherValue
		self.notFoundKey = notFoundKey
	}
}
