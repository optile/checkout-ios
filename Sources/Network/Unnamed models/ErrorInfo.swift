import Foundation

/// Error returned from a server
/// - TODO: check if all errors from the backend is returned as this type
struct ErrorInfo: Decodable, LocalizedError {
	let resultInfo: String
	let interaction: Interaction
	var errorDescription: String? { return resultInfo }
	
	struct Interaction: Decodable {
		let code, reason: String
	}
}
