import Foundation

public struct InstallmentItem: Decodable {
	/// An amount of this installment in major units.
	public let amount: Double?
	
	/// An installment (or payment) date.
	public let date: String?
}
