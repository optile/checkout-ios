import Foundation

/// Collection of links to build the account form for this registered account and perform different actions with entered data.
public struct AccountLinks {
	/// URL to retrieve details about this registered account in context of initialized `LIST`.
	public let `self`: URL
	
	/// URL where operation data should be submitted (POSTed), if customer has decided to pay with this account registration.
	public let operation: URL?
	
	/// URL to submit partial account data for in-page validation of registered account if supported.
	public let validation: URL?
	
	/// URL of payment network logo (image) for this account registration.
	public let logo: URL
	
	/// URL to retrieve a registered version of account form template. HTML snippet with account elements and message placeholders.
	public let form: URL?
	
	/// URL to retrieve localized representation of registered account form. Text placeholders are replaced by text in corresponding language, language is defined by `LIST` session.
	public let localizedForm: URL?
	
	/// If present, this URL points to the form for this payment account that has to be preloaded and initialised prior the rendering of this `LIST` session on the client side. Main goal is to accelerate rendering of the main form for this account.
	public let preloadForm: URL?
	
	/// URL of language file that contains labels and messages to localize account forms and display errors for this payment network.
	/// Language file is provided in [Java properties](http://en.wikipedia.org/wiki/.properties) format.
	public let lang: URL
	
	/// URL of iFrame what should been shown to the customer to collect account data.
	/// Present only in the case when `LIST` session was initialized with `SELECTIVE_NATIVE` integration type.
	public let iFrame: URL?
}
