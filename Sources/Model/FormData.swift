import Foundation

public class FormData: NSObject, Decodable {
	/// Account related data to pre-fill a form.
	public let account: AccountFormData?
	
	/// Customer related data to pre-fill a form.
	public let customer: CustomerFormData?
	
	/// Data about possible installments plans.
	public let installments: Installments?
	
	/// URL to the data privacy consent document.
	public let dataPrivacyConsentUrl: URL?
}
