// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

class DeregistrationData: NSObject, Codable {
    /// If set to `true` the account registrations (one-click) will be deleted if present, if set to `false` the registration remains
    var deleteRegistration: Bool?

    /// If set to `true` the recurring registrations will be deleted if present, if set to `false` the registration remains
    var deleteRecurrence: Bool?

    init(deleteRegistration: Bool?, deleteRecurrence: Bool?) {
        self.deleteRegistration = deleteRegistration
        self.deleteRecurrence = deleteRecurrence
    }
}
