// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import XCTest

// Flows should follow rules specified in https://optile.atlassian.net/browse/PCX-1396.
class UpdateFlowTests: NetworksTests {
    func testTryOtherAccount() throws {
        let transaction = try Transaction.loadFromTemplate(amount: .tryOtherAccount, operationType: .update)
        try setupWithPaymentSession(using: transaction)

        app.tables.staticTexts["Cards"].tap()
        Visa().submit(in: app.collectionViews)

        XCTAssertTrue(app.alerts.firstMatch.waitForExistence(timeout: .networkTimeout), "Alert didn't appear in time")

        let interactionResult = app.alerts.firstMatch.staticTexts.element(boundBy: 1).label
        let expectedResult = "Please verify the data you entered is correct and try again, or use another payment method."
        XCTAssertEqual(expectedResult, interactionResult)
    }

    func testProceedPending() throws {
        let transaction = try Transaction.loadFromTemplate(amount: .proceedPending, operationType: .update)
        try setupWithPaymentSession(using: transaction)

        app.tables.staticTexts["Cards"].tap()
        Visa().submit(in: app.collectionViews)

        XCTAssertTrue(app.alerts.firstMatch.waitForExistence(timeout: .networkTimeout), "Alert didn't appear in time")

        let interactionResult = app.alerts.firstMatch.staticTexts.element(boundBy: 1).label
        let expectedResult = "Please refresh or check back later for updates."
        XCTAssertEqual(expectedResult, interactionResult)
    }

    // PayPal returns `PROCEED/OK` when it updated.
    func testProceedOk() throws {
        let transaction = try Transaction.loadFromTemplate(operationType: .update)
        try setupWithPaymentSession(using: transaction)

        let payPal = PayPalAccount()

        // Bottom sheet
        app.tables.staticTexts[payPal.label].tap()
        payPal.submit(in: app.collectionViews)

        // Webview
        let button = app.webViews.staticTexts["accept"]
        XCTAssertTrue(button.waitForExistence(timeout: .networkTimeout), "Accept button didn't appear in time")
        button.tap()

        // List of networks
        waitForLoadingCompletion()
        XCTAssert(app.tables.staticTexts[payPal.label].exists, "Table with PayPal network is not found")
    }
}

// MARK: Test: SaveDeleteNewCardPaymentMethod

extension UpdateFlowTests {
    func testSaveDeleteNewCardPaymentMethod() throws {
        let transaction = try Transaction.loadFromTemplate(operationType: .update)
        try setupWithPaymentSession(using: transaction)

        let visa = Visa()

        XCTContext.runActivity(named: "Test saving the new payment method") { _ in
            deleteIfExistsPaymentMethod(withLabel: visa.maskedLabel)
            submitAndWaitForExistence(forPaymentNetwork: visa)
        }

        // Test deletion
        XCTContext.runActivity(named: "Test payment method deletion") { _ in
            deleteIfExistsPaymentMethod(withLabel: visa.maskedLabel)
            waitForLoadingCompletion()
            XCTAssertFalse(app.tables.staticTexts[visa.maskedLabel].exists, "Payment network still exists after deletion")
        }
    }

    private func deleteIfExistsPaymentMethod(withLabel label: String) {
        XCTContext.runActivity(named: "Delete payment method \(label)") { _ in
            let savedMethodText = app.tables.staticTexts[label]
            if savedMethodText.exists {
                savedMethodText.tap()
                app.navigationBars.buttons["Delete"].tap()
                app.alerts.firstMatch.buttons["Delete"].tap()
            }
        }
    }
}

// MARK: Test: DeleteButtonShouldntAppear

extension UpdateFlowTests {
    func testDeleteButtonShouldntAppear() throws {
        let visa = Visa()

        try XCTContext.runActivity(named: "Save the new payment method") { _ in
            let transaction = try Transaction.loadFromTemplate(operationType: .update)
            try setupWithPaymentSession(using: transaction)

            try addPaymentNetworkIfNeeded(visa)
        }

        try XCTContext.runActivity(named: "Delete the payment method") { _ in
            let transaction = try Transaction.loadFromTemplate(operationType: .charge)
            try setupWithPaymentSession(using: transaction)

            delete(paymentNetwork: visa)
        }
    }

    private func addPaymentNetworkIfNeeded(_ paymentNetwork: PaymentNetwork) throws {
        // Add a payment method if it doesn't exist
        if !app.tables.staticTexts[paymentNetwork.maskedLabel].exists {
            submitAndWaitForExistence(forPaymentNetwork: paymentNetwork)
        }
    }

    private func delete(paymentNetwork: PaymentNetwork) {
        app.tables.staticTexts[paymentNetwork.maskedLabel].tap()
        XCTAssertFalse(app.navigationBars.buttons["Delete"].exists, "Delete button shouldn't exist in a CHARGE flow")
    }
}

// MARK: - Class helpers

fileprivate extension UpdateFlowTests {
    /// Wait until activity indicator disappears
    func waitForLoadingCompletion() {
        XCTContext.runActivity(named: "Wait for loading completion") { _ in
            _ = app.activityIndicators.firstMatch.waitForExistence(timeout: 1)

            // Wait until loading indicator will disappear
            let notExists = NSPredicate(format: "exists == 0")
            let activityIndicatorIsFinished = expectation(for: notExists, evaluatedWith: app.activityIndicators.firstMatch, handler: nil)
            wait(for: [activityIndicatorIsFinished], timeout: 5)
        }
    }

    func submitAndWaitForExistence(forPaymentNetwork paymentNetwork: PaymentNetwork) {
        app.tables.staticTexts["Cards"].tap()
        paymentNetwork.submit(in: app.collectionViews)

        let isPaymentMethodAppeared = app.tables.staticTexts[paymentNetwork.maskedLabel].waitForExistence(timeout: .networkTimeout)
        XCTAssert(isPaymentMethodAppeared, "Payment method didn't appear in the list after saving")
    }
}
