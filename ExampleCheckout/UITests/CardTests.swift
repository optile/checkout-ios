// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import XCTest

class CardsTests: NetworksTests {
    func testVISAProceed() throws {
        // List
        app.tables.staticTexts["Cards"].tap()

        // Input
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.textFields["Card Number"].tap()
        collectionViewsQuery.textFields["Card Number"].typeText("4111111111111111")

        collectionViewsQuery.textFields["MM / YY"].tap()
        collectionViewsQuery.textFields["MM / YY"].typeText("1030")

        collectionViewsQuery.textFields["Security Code"].tap()
        collectionViewsQuery.textFields["Security Code"].typeText("111")

        collectionViewsQuery.textFields["Name on card"].tap()
        collectionViewsQuery.textFields["Name on card"].typeText("Test Test")

        collectionViewsQuery.buttons["Pay"].tap()

        // Check result
        app.alerts.firstMatch.waitForExistence(timeout: 10)

        let interactionResult = app.alerts.firstMatch.staticTexts.element(boundBy: 1).label
        let expectedResult = "ResultInfo: Approved Interaction code: PROCEED Interaction reason: OK Error: n/a"
        XCTAssertEqual(expectedResult, interactionResult)
    }

    func testClearButton() {
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
