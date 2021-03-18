// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import XCTest

class NetworksTests: XCTestCase {
    private(set) var app: XCUIApplication!
    private let paymentSessionService = PaymentSessionService()!

    // Prepare for network tests (create session, launch app, fill url)
    override func setUpWithError() throws {
        continueAfterFailure = false

        // Create payment session
        let sessionURL = try createPaymentSession()

        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        self.app = app
        app.launch()

        // Initial screen
        let tablesQuery = app.tables
        if tablesQuery.buttons["Clear text"].exists {
            tablesQuery.buttons["Clear text"].tap()
        }
        tablesQuery.textFields.firstMatch.typeText(sessionURL.absoluteString)
        tablesQuery.staticTexts["Send request"].tap()
    }

    private func createPaymentSession() throws -> URL {
        let sessionExpectation = expectation(description: "Create payment session")
        let transaction = Transaction.loadFromTemplate()

        var createSessionResult: Result<URL, Error>?

        paymentSessionService.create(using: transaction, completion: { (result) in
            createSessionResult = result
            sessionExpectation.fulfill()
        })

        wait(for: [sessionExpectation], timeout: 5)

        switch createSessionResult {
        case .success(let url): return url
        case .failure(let error): throw error
        case .none: throw "Create session result wasn't set"
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
