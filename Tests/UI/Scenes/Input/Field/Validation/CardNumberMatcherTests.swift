// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import XCTest
@testable import PayoneerCheckout

class CardNumberMatcherTests: XCTestCase {
    /// Run multiple tests for input fields.
    /// Tests configurations is stored at `MockFactory.Validation` JSON.
    func testHolderName() throws {
        let testCases = try loadTestCases()
        let validator = Input.Field.Validation.CardNumberMatcher()

        for testCase in testCases {
            XCTContext.runActivity(named: "Testing \(testCase.holderName)") { _ in
                let containsCardNumber = validator.containsCardNumber(in: testCase.holderName)
                XCTAssertNotEqual(containsCardNumber, testCase.isValid)
            }
        }
    }

    private func loadTestCases() throws -> [HolderNameTestCase] {
        let bundle = Bundle(for: CardNumberMatcherTests.self)
        let url = bundle.url(forResource: "HolderNames", withExtension: "json")!
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([HolderNameTestCase].self, from: data)
    }
}

private struct HolderNameTestCase: Decodable {
    let holderName: String
    let isValid: Bool
}
