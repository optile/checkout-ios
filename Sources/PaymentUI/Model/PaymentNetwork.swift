import Foundation
import Network

public final class PaymentNetwork {
	internal let applicableNetwork: ApplicableNetwork
	
	public let code: String
	public var label: String
	@CurrentValue var logo: UIImage? = nil
	
	init(from applicableNetwork: ApplicableNetwork) {
		self.applicableNetwork = applicableNetwork
		
		self.code = applicableNetwork.code
		self.label = applicableNetwork.label
	}
}

extension PaymentNetwork: Equatable, Hashable {
	public static func == (lhs: PaymentNetwork, rhs: PaymentNetwork) -> Bool {
		return (lhs.code == rhs.code)
	}
	
	public func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
}
