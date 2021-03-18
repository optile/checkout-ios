// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

/// Allows to change default appearance of payment page. It applies to either hosted payment page (for `HOSTED` integration type), or to the page rendered by `op-payment-widget` (see AJAX integration topic).
struct Style: Codable {
    /// Preferred language for payment page. If undefined will be decided upon country information from transaction object.
    ///
    /// Format `<language code>[_<COUNTRY CODE>]`, where `<language code>` is a mandatory part that comply with [ISO 639-1 (alpha-2)](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes), and `<COUNTRY CODE>` is an optional part that comply with [ISO 3166-1 (alpha-2)](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2).
    var language: String?
}
