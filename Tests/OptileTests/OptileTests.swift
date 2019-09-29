import XCTest
@testable import Optile

final class OptileTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Optile().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
