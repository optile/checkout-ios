import Foundation

@objc public class PaymentSession: NSObject {
	public let networks: [PaymentNetwork]
	
	public init(networks: [PaymentNetwork]) {
		self.networks = networks
		
		super.init()
	}
}
