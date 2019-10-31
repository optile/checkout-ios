import Foundation

/// Error returned from a server
/// - TODO: check if all errors from the backend is returned as this type
struct ErrorInfo: Decodable {
	let resultInfo: String
	let interaction: Interaction
	
	struct Interaction: Decodable {
		let code, reason: String
	}
}

extension ErrorInfo: Error {
	var localizedDescription: String { return resultInfo }
}
