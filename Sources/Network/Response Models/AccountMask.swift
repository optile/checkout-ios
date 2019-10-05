import Foundation

/// Masked account data of this payment operation or involved account. Sensitive fields of the account are removed, truncated, or replaced with mask characters.
public class AccountMask: NSObject, Decodable {
	/// Display label of account registration. Usually combined from several account fields.
	public let displayLabel: String?
	
	/// Account holder name.
	public let holderName: String?
	
	/// Account number (bank account number, credit card number, etc.), usually truncated.
	public let number: String?
	
	/// Bank code.
	public let bankCode: String?
	
	/// Bank name.
	public let bankName: String?
	
	/// BIC code.
	public let bic: String?
	
	/// Bank branch name.
	public let branch: String?
	
	/// Bank city or any other account related city.
	public let city: String?
	
	/// Account expiry month (credit/debit cards).
	public let expiryMonth: Int?
	
	/// Account expiry year (credit/debit cards).
	public let expiryYear: Int?
	
	/// IBAN number, usually truncated.
	public let iban: String
	
	/// Account login name.
	public let login: String
}
