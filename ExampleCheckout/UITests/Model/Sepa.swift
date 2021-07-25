// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import XCTest

struct Sepa: PaymentNetwork {
    let label = "SEPA"
    // Should be changed to masked SEPA account in future
    let maskedLabel = "SEPA"

    var holderName: String? = "Test Test"
    var iban: String? = "NL69INGB0123456789"

    func fill(in collectionView: XCUIElementQuery) {
        XCTContext.runActivity(named: "Fill SEPA's data") { _ in
            tapAndType(text: holderName, in: collectionView.textFields["Account holder name"])
            tapAndType(text: iban, in: collectionView.textFields["IBAN"])
        }
    }
}
