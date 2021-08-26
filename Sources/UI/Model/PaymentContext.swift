// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

/// Global properties that maybe usefull but not directly related to applicable network or registered account.
class PaymentContext {
    let operationType: PaymentSession.Operation
    let extraElements: ExtraElements?

    init(operationType: PaymentSession.Operation, extraElements: ExtraElements?) {
        self.operationType = operationType
        self.extraElements = extraElements
    }
}
