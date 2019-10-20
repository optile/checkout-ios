import Foundation
import PaymentNetwork

public struct PaymentSession {
	public var networks: [PaymentNetwork]
	
	public init(networks: [PaymentNetwork]) {
		self.networks = networks
	}
}
