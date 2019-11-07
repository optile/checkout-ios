import Foundation

public class PresetAccount: NSObject, Decodable {
	/// Collection of links related to this `PRESET` account.
	public let links: Dictionary<String, URL>
	
	/// Code of preset network
	public let code: String
	
	/// Masked account of preset account; sensitive fields of the account are removed, truncated, or replaced with mask characters.
	public let maskedAccount: AccountMask?

	/// Indicates that form for this account is empty, without any text and input elements.
	public let emptyForm: Bool
	
	/// Code of button-label for this preset account.
	public let button: String
	
	/// Redirect object to summary page of merchants web-site.
	public let redirect: Redirect
	
	/// Map of public available contract data from the first possible route for this preset account.
	// FIXME: What type does use that property?
	public let contractData: String?
}
