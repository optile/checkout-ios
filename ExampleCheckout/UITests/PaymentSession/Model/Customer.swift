// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

struct Customer: Codable {
    /// Customer identifier given by the merchant. Not validated for uniqueness by OPG.
    var number: String

    /// Customer e-mail address. It is highly recommended to provide it, since it is a mandatory information for some PSP and often used by advanced risk management.
    var email: String?
}
