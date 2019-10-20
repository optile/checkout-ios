import Foundation

public class Installments: NSObject, Decodable {
	/// An information about original payment
	public let originalPayment: PaymentAmount?
	
	/// Collection of calculated installments plans what should be present to customer.
	public let plans: [InstallmentsPlan]?
}
