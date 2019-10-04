import Foundation

struct PaymentError: LocalizedError, CustomDebugStringConvertible {
	var errorDescription: String?
	var debugDescription: String
	
	public init(description: String, debugDescription: String? = nil, file: String = #file, line: Int = #line, function: String = #function) {
		self.debugDescription = "Called from the file: " + file + "#" + String(line) + ", method: " + function
		self.errorDescription = description
	}
	
	static func unexpected(file: String = #file, line: Int = #line, function: String = #function) -> PaymentError {
		return .init(description: "Unexpected Error")
	}
}
