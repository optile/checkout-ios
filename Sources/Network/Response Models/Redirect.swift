import Foundation

public class Redirect: NSObject, Decodable {
	/// URL to redirect customer's browser (or any other client) to.
	public let url: URL
	
	/// Advised HTTP method to use for the redirection
	public let method: Method
	
	/// Collection of additional parameters to pass with this redirection.
	public let parameters: Parameter?
	
	/// If `true` redirect logic should ensure that IFrame is suppressed during redirection, if payment page or web-site resides inside one.
	public let suppressIFrame: Bool?
	
	/// If `true` this redirect has to be displayed in a pop-up window as a requirement from PSP.
	public let displayInPopup: Bool?
	
	/// `true` indicates that this redirect object contains parameters with placeholders that should be replaced by values from the customer payment account.
	public let сontainsAccountPlaceholders: Bool?
	
	/// Describes the type of this redirect.
	///
	///	Possible values are:
	///	  * `SUMMARY` - redirect points to the session's `summaryUrl` from transaction `callback`.
	///	  * `RETURN` - redirect points to the session's `returnUrl` from transaction `callback`.
	///	  * `CANCEL` - redirect points to the session's `cancelUrl` from transaction `callback`.
	///	  * `PROVIDER` - redirect to the external page of a provider (redirect method such as PayPal, Sofort, iDeal, etc.)
	///		or 3D Secure pages in case of credit/debit card processing.
	///
	///	- Note: new types of redirect may appear in the future for new payment use cases.
	public let type: String?
	
	// MARK: - Enumerations
	
	public enum Method: String, Decodable {
		case GET, POST
	}
}
