import Foundation

public class AccountRegistration: NSObject, Decodable {
	/// Collection of links to build the account form for this registered account and perform different actions with entered data.
	public let links: Dictionary<String, URL>
	
	/// Payment network code of the registration.
	public let code: String
	
	/// Display label of the payment network for this registration.
	public let label: String
	
	/// Masked account data of this payment operation or involved account. Sensitive fields of the account are removed, truncated, or replaced with mask characters.
	public let maskedAccount: AccountMask
	
	/// Time stamp of last successful `CHARGE` operation performed with this account.
	public let lastSuccessfulChargeAt: Date?
	
	/// Indicates that this account registration is initially selected.
	public let selected: Bool?
	
	/// IFrame height for selective native, only supplied if "iFrame" link is present.
	public let iFrameHeight: Int?
	
	/// Timestamp when this account was marked as preferred.
	public let preferredAt: Date?
	
	/// Timestamp when this account was created.
	public let createdAt: Date?
	
	/// Indicates that form for this account is empty, without any text and input elements.
	public let emptyForm: Bool?
	
	/// Collection of form input elements. This information is only exposed if merchant indicated `jsonForms` option in the `view` query parameter.
	public let localizedInputElements: InputElement?
}
