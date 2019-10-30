import Foundation

/// Error returned from a server
/// - TODO: check if all errors from the backend is returned as this type
struct ErrorInfo: Decodable, Error {
	let resultInfo: String
	let interaction: Interaction
	var errorDescription: String? { return resultInfo }
	
	struct Interaction: Decodable {
		let code, reason: String
	}
}

struct NetworkInternalError: Error, CustomDebugStringConvertible {
	var debugDescription: String
	
	public init(description: String, debugDescription: String? = nil, file: String = #file, line: Int = #line, function: String = #function) {
		self.debugDescription = description + ". Called from the file: " + file + "#" + String(line) + ", method: " + function
	}
	
	static func unexpected(file: String = #file, line: Int = #line, function: String = #function) -> NetworkInternalError {
		return .init(description: "Unexpected Error")
	}
}

struct PaymentInternalError: Error, CustomDebugStringConvertible {
	var debugDescription: String
	
	public init(description: String, debugDescription: String? = nil, file: String = #file, line: Int = #line, function: String = #function) {
		self.debugDescription = description + ". Called from the file: " + file + "#" + String(line) + ", method: " + function
	}
	
	static func unexpected(file: String = #file, line: Int = #line, function: String = #function) -> PaymentInternalError {
		return .init(description: "Unexpected Error")
	}
}
