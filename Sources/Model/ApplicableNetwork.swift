import Foundation

public class ApplicableNetwork: NSObject, Decodable {
	/// Payment network code.
	public let code: String
	
	/// Display label of the payment network.
	public let label: String
	
	/// Indicates payment method this network belongs to.
	public let method: String
	
	/// Grouping code; helps to group several payment networks together while displaying them on payment page (e.g. credit cards).
	public let grouping: String
	
	/// Indicates whether this payment network supports registration and how this should be presented on payment page
	public let registration: String
	
	/// Indicates whether this payment network supports recurring registration and how this should be presented on payment page
	public let recurrence: String
	
	/// If `true` the payment via this network will result in redirect to the PSP web-site (e.g. PayPal, Sofortüberweisung, etc.)
	public let redirect: Bool

	/// Code of button-label when this network is selected.
	public let button: String?
	
	/// If `true` this network should been initially pre-selected.
	public let selected: Bool?
	
	/// Map of public available contract data from the first possible route.
	// - FIXME: Unknown data type
	// public let contractData: String?
	
	/// Data what should been used to dynamically pre-fill a form for this network
	public let formData: FormData?
	
	/// IFrame height for selective native, only supplied if "iFrame" link is present
	public let iFrameHeight: Int?
	
	/// Indicates that form for this network is empty, without any text and input elements
	public let emptyForm: Bool?
	
	///  Collection of form input elements. This information is only exposed if merchant indicated `jsonForms` option in the `view` query parameter.
	public let localizedInputElements: [InputElement]?
	
	/// Collection of links related to this payment network in scope of the `LIST` session
	public let links: Dictionary<String, URL>?
}
