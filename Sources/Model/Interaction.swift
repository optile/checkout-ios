import Foundation

public class Interaction: NSObject, Decodable {
	/// Interaction code that advices further interaction with this customer or payment.
	/// See list of [Interaction Codes](https://www.optile.io/opg#292619).
	public let code: String
	
	/// Reason of this interaction, complements interaction code and has more detailed granularity.
	/// See list of [Interaction Codes](https://www.optile.io/opg#292619).
	public let reason: String
}
