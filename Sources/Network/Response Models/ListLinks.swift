import Foundation

public struct ListLinks: Decodable {
	/// Link to `LIST` session itself
	public let `self`: URL
	
	/// Link to customer information resource
	public let customer: URL?
}
