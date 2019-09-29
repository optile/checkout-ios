import Foundation

struct APIError: LocalizedError, CustomDebugStringConvertible {
	var errorDescription: String?
	var debugDescription: String
	
	public init(description: String, debugDescription: String? = nil, file: String = #file, line: Int = #line, function: String = #function) {
		self.debugDescription = "Called from the file: " + file + "#" + String(line) + ", method: " + function
		self.errorDescription = description
	}
	
	static func unexpected(file: String = #file, line: Int = #line, function: String = #function) -> APIError {
		return .init(description: "Unexpected Error")
	}
}

/// Error returned from a server
/// - TODO: check if all errors from the backend is returned as this type
struct OptileError: Decodable {
	let resultInfo: String
	let interaction: Interaction
	
	struct Interaction: Decodable {
		let code, reason: String
	}
}
