import Foundation

public struct PaymentSession {
	public var networks: [PaymentNetwork]
	
	public init(networks: [PaymentNetwork]) {
		self.networks = networks
	}
}
