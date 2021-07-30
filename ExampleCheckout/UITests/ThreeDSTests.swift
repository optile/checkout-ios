// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import XCTest

// Flows should follow rules specified in https://optile.atlassian.net/wiki/spaces/PPW/pages/2228158566/3DS2+-+TESTPSP.
class ThreeDSTests: NetworksTests {
    func testProceedOk() throws {
        let transaction = try Transaction.loadFromTemplate(amount: .threeDS, operationType: .charge)
        try setupWithPaymentSession(using: transaction)

        app.tables.staticTexts["Cards"].tap()
        Visa().submit(in: app.collectionViews)

        // Webview

        let button = app.webViews.staticTexts["accept payment"]
        XCTAssertTrue(button.waitForExistence(timeout: .networkTimeout), "Button didn't appear in time")
        button.tap()

        // Alert

        XCTAssertTrue(app.alerts.firstMatch.waitForExistence(timeout: .networkTimeout), "Alert didn't appear in time")

        let interactionResult = app.alerts.firstMatch.staticTexts.element(boundBy: 1).label
        XCTAssert(interactionResult.contains("PROCEED"))
        XCTAssert(interactionResult.contains("OK"))
    }

    func testProceedPending() throws {
        let transaction = try Transaction.loadFromTemplate(amount: .threeDS, operationType: .charge)
        try setupWithPaymentSession(using: transaction)

        app.tables.staticTexts["Cards"].tap()
        Visa().submit(in: app.collectionViews)

        // Webview

        let challengeButton = app.webViews.staticTexts["request challenge"]
        XCTAssertTrue(challengeButton.waitForExistence(timeout: .networkTimeout), "Button didn't appear in time")
        challengeButton.tap()

        let acceptButton = app.webViews.staticTexts["accept"]
        XCTAssertTrue(acceptButton.waitForExistence(timeout: .networkTimeout), "Button didn't appear in time")
        acceptButton.tap()

        // Alert

        XCTAssertTrue(app.alerts.firstMatch.waitForExistence(timeout: .networkTimeout), "Alert didn't appear in time")

        let interactionResult = app.alerts.firstMatch.staticTexts.element(boundBy: 1).label
        XCTAssert(interactionResult.contains("PROCEED"))
        
        if !interactionResult.contains("OK") && !interactionResult.contains("PENDING") {
            XCTFail("Interaction reason is not OK or PENDING")
        }
    }

    func testAbort() throws {
        let transaction = try Transaction.loadFromTemplate(amount: .threeDS, operationType: .charge)
        try setupWithPaymentSession(using: transaction)

        app.tables.staticTexts["Cards"].tap()
        Visa().submit(in: app.collectionViews)

        // Webview

        let challengeButton = app.webViews.staticTexts["request challenge"]
        XCTAssertTrue(challengeButton.waitForExistence(timeout: .networkTimeout), "Button didn't appear in time")
        challengeButton.tap()

        let acceptButton = app.webViews.staticTexts["abort"]
        XCTAssertTrue(acceptButton.waitForExistence(timeout: .networkTimeout), "Button didn't appear in time")
        acceptButton.tap()

        // Alert

        XCTAssertTrue(app.alerts.firstMatch.waitForExistence(timeout: .networkTimeout), "Alert didn't appear in time")

        let alertTitle = app.alerts.firstMatch.staticTexts.element(boundBy: 0).label
        let expectedTitle = "Payment interrupted"
        XCTAssertEqual(alertTitle, expectedTitle)

        let alertText = app.alerts.firstMatch.staticTexts.element(boundBy: 1).label
        let expectedText = "Please try again."
        XCTAssertEqual(alertText, expectedText)
    }
}
