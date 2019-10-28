import Foundation

struct TestError: Error, CustomDebugStringConvertible {
	var debugDescription: String
	
	init(description: String) {
		self.debugDescription = description
	}
}
