import Foundation

public final class PaymentSession {
	public var networks: [PaymentNetwork]
	
	public init(networks: [PaymentNetwork]) {
		self.networks = networks
	}
}
