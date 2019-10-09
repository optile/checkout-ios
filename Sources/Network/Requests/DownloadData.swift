import Foundation

// MARK: - Request

/// Gets active LIST session details
///
/// Retrieves available payment capabilities for active `LIST` session.
/// Response model is `
public struct DownloadData: GetRequest {
	public var url: URL
	let queryItems = [URLQueryItem]()
	public typealias Response = Data
	
	/// - Parameter url: `self` link from payment session
	public init(from url: URL) {
		self.url = url
	}
}
