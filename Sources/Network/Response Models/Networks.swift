import Foundation

public class Networks: NSObject, Decodable {
	/// Collection of applicable payment networks that could be used by a customer to complete the payment in scope of this `LIST` session
	public let applicable: [ApplicableNetwork]
}
