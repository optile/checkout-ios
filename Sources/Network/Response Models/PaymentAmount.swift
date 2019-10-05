import Foundation

public class PaymentAmount: NSObject, Decodable {
	/// Payment amount in major units.
	public let amount: Double
	
	/// 3-letter currency code (ISO 4217)
	public let currency: String
}
