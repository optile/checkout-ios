import Foundation

/// Collection of different parameters to identify this operation supplied by merchant, optile and PSP.
public struct Identification {
	/// Globally unique operation identifier assigned by OPG platform
	public let longId: String
	
	/// Short identifier assigned by OPG platform to operation. Unlike longId this identifier is not guaranteed to be unique.
	public let shortId: String
	
	/// Original transaction ID provided by merchant during `LIST` session initialization, or during recurring `CHARGE`.
	public let transactionId: String
	
	/// ID assigned by PSP if successful communication with PSP took place in scope of this operation.
	public let pspId: String?
	
	/// ID assigned by financial institution if successful communication with institution took place in scope of this operation.
	public let institutionId: String?
}
