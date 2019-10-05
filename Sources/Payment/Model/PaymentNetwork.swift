import Foundation

@objc public class PaymentNetwork: NSObject {
	public let label: String
	public let logoURL: URL?
	public var logoData: Data?
	
	public init(label: String, logoURL: URL?) {
		self.label = label
		self.logoURL = logoURL

		super.init()
	}
}
