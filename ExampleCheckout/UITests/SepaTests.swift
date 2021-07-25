// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import XCTest

class SepaTests: NetworksTests {
    func testSuccessPayment() throws {
        let transaction = try Transaction.loadFromTemplate(amount: .proceedOk, operationType: .charge)
        try setupWithPaymentSession(using: transaction)

        app.tables.staticTexts["SEPA"].tap()
        Sepa().submit(in: app.collectionViews)

        // Check result
        XCTAssertTrue(app.alerts.firstMatch.waitForExistence(timeout: .networkTimeout), "Alert didn't appear in time")

        let interactionResult = app.alerts.firstMatch.staticTexts.element(boundBy: 1).label
        let expectedResult = "ResultInfo: Approved Interaction code: PROCEED Interaction reason: OK Error: n/a"
        XCTAssertEqual(expectedResult, interactionResult)
    }
}
