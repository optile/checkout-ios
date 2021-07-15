// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import XCTest

struct Visa: PaymentNetwork {
    /// Number without spaces
    var number: String = "4111111111111111"

    /// Date without formatting, e.g.: `1030`
    var expiryDate: String? = "1030"

    var verificationCode: String? = "111"
    var holderName: String? = "Test Test"

    let label: String = "Visa •••• 1111"

    func fill(in collectionView: XCUIElementQuery) {
        XCTContext.runActivity(named: "Fill VISA card's data") { _ in
            tapAndType(text: number, in: collectionView.textFields["Card Number"])
            tapAndType(text: expiryDate, in: collectionView.textFields["MM / YY"])
            tapAndType(text: verificationCode, in: collectionView.textFields["CVV"])
            tapAndType(text: holderName, in: collectionView.textFields["Name on card"])
        }
    }
}
