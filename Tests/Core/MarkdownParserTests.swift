// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import XCTest
@testable import PayoneerCheckout

final class MarkdownParserTests: XCTestCase {
    private var parser: MarkdownParser!

    override func setUp() {
        super.setUp()

        parser = MarkdownParser()
    }

    override func tearDown() {
        parser = nil

        super.tearDown()
    }

    func testParse_whenInputIsEmpty_shouldReturnEmpty() {
        let input = ""
        let result = parser.parse(input)
        XCTAssertEqual(result.string, "")
    }

    func testParse_whenInputContains0Links_shouldReturnAttributedStringWithInput() {
        let input = "Lorem ipsum dolor sit er elit lamet"
        let result = parser.parse(input)
        XCTAssertEqual(result.string, input)
    }

    func testParse_whenInputContainsLinks_shouldReturnStringContainingLinkText() {
        let input = "By clicking the button, you agree to the [Terms of Service](https://www.apple.com/) and [Privacy Policy](https://www.google.com/)."
        let result = parser.parse(input)
        XCTAssertEqual(result.string, "By clicking the button, you agree to the Terms of Service and Privacy Policy.")
    }

    func testParseLinks_whenInputContains1Link_shouldReturnAttributedStringWith1Link() {
        let input = "[Terms of Service](https://www.apple.com/)."
        let links = parser.parseLinks(in: input)
        XCTAssertEqual(links.count, 1)
    }

    func testParseLinks_whenInputContainsTextAndLink_shouldReturnAttributedStringWith1Link() {
        let input = "By clicking the button, you agree to the [Terms of Service](https://www.apple.com/)."
        let links = parser.parseLinks(in: input)
        XCTAssertEqual(links.count, 1)
    }

    func testParseLinks_whenInputContains2Links_shouldReturnAttributedStringWith2Links() {
        let input = "By clicking the button, you agree to the [Terms of Service](https://www.apple.com/) and [Privacy Policy](https://www.google.com/)."
        let links = parser.parseLinks(in: input)
        XCTAssertEqual(links.count, 2)
    }

    func testParseLinks_whenInputContains2LinksTogether_shouldReturnAttributedStringWith2Links() {
        let input = "By clicking the button, you agree to the [Terms of Service](https://www.apple.com/)[Privacy Policy](https://www.google.com/)."
        let links = parser.parseLinks(in: input)
        XCTAssertEqual(links.count, 2)
    }

    func testParseLinks_whenInputContains2LinksWithoutWhitespace_shouldReturnAttributedStringWith2Links() {
        let input = "By clicking the button, you agree to the [Terms of Service](https://www.apple.com/)and[Privacy Policy](https://www.google.com/)."
        let links = parser.parseLinks(in: input)
        XCTAssertEqual(links.count, 2)
    }

    func testParseLinks_whenInvalidURL_shouldReturn0Links() {
        let input = "By clicking the button, you agree to the [Terms of Service]()."
        let links = parser.parseLinks(in: input)
        XCTAssertEqual(links.count, 0)
    }
}
