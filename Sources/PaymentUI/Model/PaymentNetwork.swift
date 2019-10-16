import Foundation
import Network

#if canImport(UIKit)
import UIKit
#endif

public final class PaymentNetwork {
	internal let applicableNetwork: ApplicableNetwork
	
	public let code: String
	public var label: String
	
	#if canImport(UIKit)
	@CurrentValue var logo: UIImage? = nil
	#endif
	
	init(from applicableNetwork: ApplicableNetwork) {
		self.applicableNetwork = applicableNetwork
		
		self.code = applicableNetwork.code
		self.label = String()
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
