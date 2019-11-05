import XCTest
@testable import Payment

class PaymentSessionServiceTests: XCTestCase {
	func testPaymentPageUnavailable() {
		let result = syncLoadPaymentSession(using: PaymentPageFailureDataSource())
		
		guard case let .failure(error) = result else {
			XCTFail("Expected failure")
			return
		}
		
		let errorAttach = XCTAttachment(subject: error)
		errorAttach.name = "Error"
		add(errorAttach)
		
		guard let localized = error as? LocalizedError else {
			XCTFail("Error is not localized")
			return
		}
		
		XCTAssertEqual(localized.localizedDescription, LocalTranslation.errorDefault.localizedString)
	}
	
	// TODO:
	// Write a test if payment network doesn't contain language URL or download failed
	
	func testValid() {
		let result = syncLoadPaymentSession(using: PaymentSessionDataSource())
		
		guard case let .success(session) = result else {
			XCTFail("Expected success")
			return
		}

		XCTAssertEqual(session.networks.count, 4)
		XCTAssertEqual(session.networks[1].label, "Visa Electron Localized")
	}
	
	// MARK: - Helper methods
	
	private func syncLoadPaymentSession(using dataSource: MockDataSource) -> Load<PaymentSession, PaymentError> {
		let connection = MockConnection(dataSource: dataSource)
		let provider = PaymentSessionService(paymentSessionURL: URL.example, connection: connection, localizationProvider: SharedTranslationProvider())
		
		let loadingPromise = expectation(description: "PaymentSessionProvider: loading")
		let resultPromise = expectation(description: "PaymentSessionProvider: completed")
		var sessionResult: Load<PaymentSession, PaymentError>!
		provider.loadPaymentSession { result in
			switch result {
			case .loading: loadingPromise.fulfill()
			default:
				sessionResult = result
				resultPromise.fulfill()
			}
		}
		wait(for: [loadingPromise, resultPromise], timeout: 1, enforceOrder: true)
		
		let attachment = XCTAttachment(subject: sessionResult)
		attachment.name = "LoadPaymentSessionResult"
		add(attachment)
		
		return sessionResult
	}
}

// MARK: - Data Sources

private class PaymentPageFailureDataSource: MockDataSource {
	func fakeData(for request: URLRequest) -> Result<Data?, Error> {
		guard let path = request.url?.path else {
			let error = TestError(description: "Request doesn't contain URL")
			XCTFail(error)
			return .failure(error)
		}
		
		switch path {
		case "":
			return MockFactory.ListResult.listResult.fakeData(for: request)
		case let s where s.contains("paymentpage.properties"):
			let error = TestError(description: "No payment page localization")
			return .failure(error)
		default:
			let error = TestError(description: "Unexpected URL was requested")
			XCTFail(error)
			return .failure(error)
		}
	}
}


private class PaymentSessionDataSource: MockDataSource {
	func fakeData(for request: URLRequest) -> Result<Data?, Error> {
		guard let path = request.url?.path else {
			let error = TestError(description: "Request doesn't contain URL")
			XCTFail(error)
			return .failure(error)
		}
		
		switch path {
		case "":
			return MockFactory.ListResult.listResult.fakeData(for: request)
		case let s where s.contains("paymentpage.properties"):
			return MockFactory.Localization.paymentPage.fakeData(for: request)
		case let s where s.contains(".properties"):
			return MockFactory.Localization.paymentNetwork.fakeData(for: request)
		default:
			let error = TestError(description: "Unexpected URL was requested")
			XCTFail(error)
			return .failure(error)
		}
	}
}
