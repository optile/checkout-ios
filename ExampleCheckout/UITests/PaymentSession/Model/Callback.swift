// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

/// Callback information about merchants shop system. It is strongly advised to provide this data with every transaction.
struct Callback: Codable {
    var appId: String

    /// URL of landing page in merchants shop system after customer select payment method. This property is mandatory for a `LIST` session with `operationType` of `PRESET`, or with deprecated `presetFirst` option set to `true`.
    var summaryUrl: String?

    /// Payment status notification URL. If defined, the OPG system will send asynchronous status notifications about this payment to this URL.
    ///
    /// - Note: merchant can configure a single notification URL for all transactions on the _division_ level via Merchant Configuration API. Notification URL in `callback`, however, overrides the division settings.
    var notificationUrl: String?
}
