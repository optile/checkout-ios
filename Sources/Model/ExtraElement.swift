// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

class ExtraElement: NSObject, Decodable {
    let name: String?
    let label: String?

    /// Checkbox parameters, 'null' if this extra element is a label.
    let checkbox: Checkbox?
}
