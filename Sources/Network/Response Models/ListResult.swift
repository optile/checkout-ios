import Foundation

/// List response with possible payment networks
public struct NetworkList: Decodable {
	///  Date and time this `LIST` session was initialized at.
	public let timestamp: String
	
	/// Type of this operation
	public let operation: Operation
	
	/// Result code of this `LIST` session. See list of all [Result Codes](https://www.optile.io/opg#294007).
	public let resultCode: String
	
	/// Descriptive information that complements the result code and interaction advice.
	public let resultInfo: String
	
	/// Complements `resultCode` property with information about unified name and source of the operation result code.
	public let returnCode: ReturnCode?
	
	/// Current status of this `LIST` session. See list of all [Status Codes](https://www.optile.io/opg#285186).
	public let status: Status
	
	/// Interaction advice for this `LIST` session according to its current state.
	public let interaction: Interaction
	
	/// Collection of different parameters to identify this operation supplied by merchant, optile and PSP.
	public let identification: Identification
	
	/// Collection of registered accounts (if available) for recurring customer.
	public let accounts: [AccountRegistration]?
	
	///
	public let routing: Routing
	
	// MARK: - Enumerations
	
	public enum Operation {
		case LIST
	}
}
