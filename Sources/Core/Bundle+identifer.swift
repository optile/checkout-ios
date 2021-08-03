// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

extension Bundle {
    static var frameworkIdentifier: String {
        return Bundle(for: AssetProvider.self).bundleIdentifier ?? "com.payoneer.checkout"
    }
}
