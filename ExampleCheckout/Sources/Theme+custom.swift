// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import PayoneerCheckout

extension Theme {
    static var custom: Theme {
        return Theme(
            font: UIFont(name: "Georgia", size: UIFont.preferredFont(forTextStyle: .body).pointSize)!,
            backgroundColor: .white,
            tableBorder: .init(red: 0.56, green: 0.58, blue: 0.60, alpha: 1),
            tableCellSeparator: .init(red: 0.94, green: 0.95, blue: 0.95, alpha: 1),
            textColor: .init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
            detailTextColor: .init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.8),
            buttonTextColor: .white,
            tintColor: .init(red: 0, green: 0.26, blue: 0.67, alpha: 1),
            errorTextColor: .init(red: 1, green: 0.28, blue: 0, alpha: 1)
        )
    }
}
