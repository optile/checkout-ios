// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import XCTest

struct PayPalAccount: PaymentNetwork {
    let label = "PayPal"
    let maskedLabel = "PayPal"

    func fill(in collectionView: XCUIElementQuery) {}
}
