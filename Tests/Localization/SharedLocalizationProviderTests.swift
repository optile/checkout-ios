import XCTest
@testable import Payment

class SharedLocalizationProviderTests: XCTestCase {
	func testSuccessDownload() {
		let localTranslation = ["test1": "value1", "test2": "value2"]
		
		let connection = SuccessConnection()
		let provider = SharedLocalizationProvider(connection: connection, localTranslations: localTranslation)
		let promise = expectation(description: "SharedLocalizationProvider response")
		provider.download(using: URL.example) { result in
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
			
			XCTAssertEqual(dictionaries[0]["account.holderName.label"], "Holder Name")
			XCTAssertEqual(dictionaries[0].count, 61)
			
			XCTAssertEqual(dictionaries[1], localTranslation)
			
			promise.fulfill()
		}
		wait(for: [promise], timeout: 1)
	}
	
	func testFailedDownload() {
		let testError = TestError(errorDescription: "Test error")
		let connection = FailedConnection(error: testError)
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
	
	func testURLTransformation() {
		let applicableNetworkLangURL = URL(string: "https://resources.sandbox.oscato.com/resource/lang/VASILY_DEMO/en_US/VISAELECTRON.properties")!
		let connection = TestURLConnection()
		let provider = SharedLocalizationProvider(connection: connection)
		
		let promise = expectation(description: "SharedLocalizationProvider response")
		provider.download(using: applicableNetworkLangURL) { result in
			promise.fulfill()
		}
		wait(for: [promise], timeout: 1)
		
		XCTAssertEqual(connection.requestedURL, URL(string: "https://resources.sandbox.oscato.com/resource/lang/VASILY_DEMO/en_US/paymentpage.properties?")!)
	}
}

// MARK: - Connections

private class SuccessConnection: FakeConnection {
	func fakeData(for request: URLRequest) -> Result<Data?, Error> {
		return .success(data)
	}
	
	var data: Data {
		let properties = """
			network.label=Visa Electron

			account.number.label=Card Number
			account.number.placeholder=13 to 19 digits
			account.expiryMonth.label=Expiry month
			account.expiryMonth.placeholder=MM
			account.expiryYear.label=Expiry year
			account.expiryYear.placeholder=YY
			account.expiryDate.label=Valid Thru Month / Year
			account.expiryDate.placeholder=MM / YY
			account.verificationCode.label=Security Code
			account.verificationCode.generic.placeholder=CVV
			account.verificationCode.specific.placeholder=3 digits
			account.holderName.label=Holder Name
			account.holderName.placeholder=Name on card

			account.expiryMonth.01=01
			account.expiryMonth.02=02
			account.expiryMonth.03=03
			account.expiryMonth.04=04
			account.expiryMonth.05=05
			account.expiryMonth.06=06
			account.expiryMonth.07=07
			account.expiryMonth.08=08
			account.expiryMonth.09=09
			account.expiryMonth.10=10
			account.expiryMonth.11=11
			account.expiryMonth.12=12
			account.expiryYear.2019=2019
			account.expiryYear.2020=2020
			account.expiryYear.2021=2021
			account.expiryYear.2022=2022
			account.expiryYear.2023=2023
			account.expiryYear.2024=2024
			account.expiryYear.2025=2025
			account.expiryYear.2026=2026
			account.expiryYear.2027=2027
			account.expiryYear.2028=2028
			account.expiryYear.2029=2029
			account.expiryYear.2030=2030
			account.expiryYear.2031=2031
			account.expiryYear.2032=2032
			account.expiryYear.2033=2033

			error.INVALID_ACCOUNT_NUMBER=Invalid card number!
			error.MISSING_ACCOUNT_NUMBER=Missing card number
			error.INVALID_EXPIRY_MONTH=Invalid expiry month!
			error.MISSING_EXPIRY_MONTH=Missing expiry month
			error.INVALID_EXPIRY_YEAR=Invalid expiry year!
			error.MISSING_EXPIRY_YEAR=Missing expiry year
			error.INVALID_EXPIRY_DATE=Invalid expiry date!
			error.MISSING_EXPIRY_DATE=Missing expiry date
			error.INVALID_VERIFICATION_CODE=Invalid verification code!
			error.MISSING_VERIFICATION_CODE=Missing verification code
			error.INVALID_HOLDER_NAME=Invalid holder name!
			error.MISSING_HOLDER_NAME=Missing holder name

			account.verificationCode.hint.what.title=What is the Cardholder Verification Value?
			account.verificationCode.hint.what.text=The Cardholder Verification Value (CVV) is a 3-digit code ensuring that the physical card is in the cardholder's possession while shopping online.
			account.verificationCode.hint.where.title=Where can I find it?
			account.verificationCode.hint.where.text=The security code is a 3-digit number on the back side of your card.
			account.verificationCode.hint.where.shortText=Last 3 digits on card's back side.
			account.verificationCode.hint.why.title=What does it do?
			account.verificationCode.hint.why.text=The CVV code helps organizations to prevent unauthorized or fraudaulent  use. The CVV is sent electronically to the card-issuing bank to verify its validity. The  result is returned in real-time with the authorization of the payment amount.
			account.verificationCode.length=3
		"""
		
		return properties.data(using: .utf8)!
	}
}

private struct FailedConnection: FakeConnection {
	let error: Error
	
	func fakeData(for request: URLRequest) -> Result<Data?, Error> {
		let error = TestError(errorDescription: "Test error")
		return .failure(error)
	}
}

private class TestURLConnection: FakeConnection {
	private(set) var requestedURL: URL? = nil
	
	func fakeData(for request: URLRequest) -> Result<Data?, Error> {
		requestedURL = request.url
		return .success(nil)
	}
}
