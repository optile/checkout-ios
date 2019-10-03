import Foundation

// MARK: - Request

/// Gets active LIST session details
///
/// Retrieves available payment capabilities for active `LIST` session.
/// Response model is `
public struct GetListResult: GetRequest {
	public var url: URL
	let queryItems = [
		URLQueryItem(name: "view", value: "jsonForms,-htmlForms")
		]
	public typealias Response = ListResult
	
	/// - Parameter url: `self` link from payment session
	public init(url: URL) {
		self.url = url
	}
}
