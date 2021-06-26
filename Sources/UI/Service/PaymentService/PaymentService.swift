// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit
import SafariServices

protocol PaymentService: AnyObject {
    /// Returns whether the service can make payments
    static func isSupported(networkCode: String, paymentMethod: String?) -> Bool

    func send(operationRequest: OperationRequest)
    var delegate: PaymentServiceDelegate? { get set }

    init(using connection: Connection)
}

protocol PaymentServiceDelegate: AnyObject {
    func paymentService(didReceiveResponse response: PaymentServiceParsedResponse, for request: OperationRequest)
}
