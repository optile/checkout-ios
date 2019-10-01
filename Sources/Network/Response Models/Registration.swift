import Foundation

/// Information about entity registration in OPG. Refers to the registration of a customer or an account in OPG system.
public struct Registration {
	/// Registration ID within OPG platform. Generated and supplied to merchant when an entity like a customer or account or other gets registered in OPG for the first time in scope of this merchant.
	public let id: String
	
	/// Registration password. Required to access entity details stored at optile.
	public let password: String?
}
