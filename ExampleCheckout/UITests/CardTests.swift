// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import XCTest

class CardsTests: NetworksTests {
    
    // MARK: Success Card Payment
    
    func testProceedOk() throws {
        let transaction = try Transaction.loadFromTemplate(amount: .proceedOk, operationType: .charge)
        try setupWithPaymentSession(using: transaction)

        app.tables.staticTexts["Cards"].tap()
        Visa().submit(in: app.collectionViews)

        // Check result
        XCTAssertTrue(app.alerts.firstMatch.waitForExistence(timeout: .networkTimeout), "Alert didn't appear in time")

        let interactionResult = app.alerts.firstMatch.staticTexts.element(boundBy: 1).label
        let expectedResult = "ResultInfo: Approved Interaction code: PROCEED Interaction reason: OK Error: n/a"
        XCTAssertEqual(expectedResult, interactionResult)
    }
    
    func testProceedPending() throws {
        let transaction = try Transaction.loadFromTemplate(amount: .proceedPending, operationType: .charge)
        try setupWithPaymentSession(using: transaction)

        app.tables.staticTexts["Cards"].tap()
        Visa().submit(in: app.collectionViews)

        // Check result
        XCTAssertTrue(app.alerts.firstMatch.waitForExistence(timeout: .networkTimeout), "Alert didn't appear in time")

        let interactionResult = app.alerts.firstMatch.staticTexts.element(boundBy: 1).label
        let expectedResult = "ResultInfo: Pending, you have to check the status later Interaction code: PROCEED Interaction reason: PENDING Error: n/a"
        XCTAssertEqual(expectedResult, interactionResult)
    }
    
    // MARK: Retry Card Payment

    func testRetry() throws {
        let transaction = try Transaction.loadFromTemplate(amount: .retry, operationType: .charge)
        try setupWithPaymentSession(using: transaction)

        app.tables.staticTexts["Cards"].tap()
        let visa = Visa()
        visa.submit(in: app.collectionViews)

        // Check result
        XCTAssertTrue(app.alerts.firstMatch.waitForExistence(timeout: .networkTimeout), "Alert didn't appear in time")

        // Retry alert
        let interactionResult = app.alerts.firstMatch.staticTexts.element(boundBy: 1).label
        let expectedResult = "Something went wrong. Please try again later or use another payment method."
        XCTAssertEqual(expectedResult, interactionResult)
        
        // Check input fields
        app.alerts.buttons.firstMatch.tap()
        let nameTextField = app.collectionViews.textFields["Name on card"]
        XCTAssert(nameTextField.exists, "Couldn't find holder name input field")
        XCTAssertEqual(nameTextField.value as? String, visa.holderName, "Couldn't find previosly typed holder name")
    }
    
    // MARK: Interface tests

    func testClearButton() throws {
        try setupWithPaymentSession()

        // List
        app.tables.staticTexts["Cards"].tap()

        // Input
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.textFields["Card Number"].tap()

        let clearButton = app.collectionViews.buttons["iconClear"]
        let cardNumberTextField = collectionViewsQuery.textFields["Card Number"]

        XCTAssertFalse(clearButton.exists, "Clear button should be hidden")

        cardNumberTextField.typeText("4111")
        XCTAssertTrue(clearButton.exists, "Clear button should be visible")

        clearButton.tap()
        XCTAssertEqual(cardNumberTextField.value as? String, "", "Text wasn't cleared")
        XCTAssertFalse(clearButton.exists, "Clear button should be hidden")
    }
}
