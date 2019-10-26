import XCTest

func XCTFail(_ error: Error, file: StaticString = #file, line: UInt = #line) {
	XCTFail(String(describing: error), file: file, line: line)
}
