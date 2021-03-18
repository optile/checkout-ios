// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

func XCTFail(_ error: Error, file: StaticString = #file, line: UInt = #line) {
    XCTFail(String(describing: error), file: file, line: line)
}
