import Foundation

/// Collection of URLs to build the account form for this payment network and perform different actions with entered account.
public struct NetworkLinks: Decodable {
	/// URL of this applicable network.
	public let `self`: URL
	
	/// URL where operation data should be submitted (POSTed), if customer has decided to pay (or pay out) with this payment network.
	/// - Note: Not present if the `LIST` was initialized with SELECTIVE_NATIVE integration type.
	public let operation: URL?
	
	/// URL of this payment network logo (image).
	public let logo: URL
	
	/// URL to retrieve an account form template; template is an HTML snippet with account elements and message placeholders.
	/// - Note: Not present if the `LIST` was initialized with SELECTIVE_NATIVE integration type.
	public let form: URL?
	
	/// URL to submit account for in-page validation if supported.
	/// - Note: Not present if the `LIST` was initialized with SELECTIVE_NATIVE integration type.
	public let validation: URL?
	
	/// URL to retrieve localized representation of account form; text placeholders are replaced by text in corresponding language, language is defined by `LIST` session.
	/// - Note: Not present if the `LIST` was initialized with SELECTIVE_NATIVE integration type
	public let localizedForm: URL?
	
	///  If present, this URL points to the form for this payment network that has to be preloaded and initialized prior the rendering of this `LIST` session on the client side. Main goal is to accelerate rendering of the main form for this payment network.
	public let preloadForm: URL?
	
	/// URL of language file that contains labels and messages to localize account forms and display errors for this payment network; language file is provided in [Java properties format](http://en.wikipedia.org/wiki/.properties).
	public let lang: URL
	
	/// URL of iFrame what should been shown to the customer to collect account data.
	/// Present only in the case when `LIST` session was initialized with `SELECTIVE_NATIVE` integration type.
	public let iFrame: URL?
}
