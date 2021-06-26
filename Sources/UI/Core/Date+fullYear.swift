// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

extension DateFormatter {
    /// Convert short year format to a full year (yy -> yyyy).
    /// - Throws: `InternalError` if conversion fails
    /// - Returns: year in 4 digits format
    static func string(fromShortYear YY: String) throws -> String {
        guard YY.count == 2 else {
            throw InternalError(description: "Input year contains incorrect number of digits: %@", YY)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy"
        guard let date = dateFormatter.date(from: YY) else {
            throw InternalError(description: "Unable to create a date from input string: %@", YY)
        }

        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
}
