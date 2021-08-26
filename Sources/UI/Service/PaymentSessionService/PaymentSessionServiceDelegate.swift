// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

protocol PaymentSessionServiceDelegate: AnyObject {
    func paymentSessionService(loadingDidCompleteWith result: Load<PaymentSession, ErrorInfo>)
    func paymentSessionService(shouldSelect network: PaymentNetwork, context: PaymentContext)
}
