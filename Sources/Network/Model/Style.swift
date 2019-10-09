import Foundation

public class _Style: NSObject, Decodable {
	/// Preferred language for payment page. If undefined will be decided upon country information from transaction object.
	///
	/// Format `<language code>[_<COUNTRY CODE>]`, where `<language code>` is a mandatory part that comply with[ISO 639-1 (alpha-2)](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes), and `<COUNTRY CODE>` is an optional part that comply with [ISO 3166-1 (alpha-2)](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2).
	///
	/// Examples: `de` - for German, `de_CH` - for Swiss German
	public let language: String?
	
	/// Challenge Window size the issuer should use to display the challenge. If the input value does not match any of the possible values, a default option specific to payment service provider will be used.
	///
	/// Possible values (enumerated in 3DS2 specification):
	/// - `fullPage`
	/// - `250x400`
	/// - `390x400`
	/// - `500x600`
	/// - `600x400`
	public let challengeWindowSize: String?
	
	/// URL of merchant custom CSS for payment page. It can be hosted anywhere but must be accessible through "https" protocol.
	public let cssOverride: String?
}
