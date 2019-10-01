import Foundation

public struct Parameter: Decodable {
	/// Parameter name.
	public let name: String
	
	/// Parameter value.
	public let value: String?
}
