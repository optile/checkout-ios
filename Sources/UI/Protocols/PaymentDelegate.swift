// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

/// A protocol used to implement event handling for payment service events.
@objc public protocol PaymentDelegate: AnyObject {
    /// Method is called when payment result was received, you should handle a payment result and dismiss a view manually
    /// - Parameters:
    ///   - controller: payment view controller, it should be dismissed
    @objc func paymentService(didReceivePaymentResult paymentResult: PaymentResult, viewController: PaymentListViewController)
}
