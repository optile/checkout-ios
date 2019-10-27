import Foundation

public struct PaymentNetwork {
	internal let applicableNetwork: ApplicableNetwork
	
	public let code: String
	public var label: String
	
	var logoData: Data? = nil
	
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
