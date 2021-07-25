// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import XCTest

protocol PaymentNetwork {
    /// Network label
    var label: String { get }

    /// Masked label for saved account
    var maskedLabel: String { get }

    /// Fill collection view with input fields with card's data.
    /// - Parameters:
    ///   - collectionView: collection view with input fields
    ///   - shouldSubmit: click the submit button (like `Pay` or `Save`) upon filling
    func fill(in collectionView: XCUIElementQuery)

    /// Fill and submit a payment with card's data.
    func submit(in collectionView: XCUIElementQuery)
}

extension PaymentNetwork {
    func submit(in collectionView: XCUIElementQuery) {
        fill(in: collectionView)
        collectionView.buttons.firstMatch.tap()
    }
}

extension PaymentNetwork {
    func tapAndType(text: String?, in textField: XCUIElement) {
        guard let text = text else { return }

        XCTAssertTrue(textField.exists)
        textField.tap()
        textField.typeText(text)
    }
}
