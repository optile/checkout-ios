import Foundation

public class PaymentNetwork {
	public let code: String
	public let label: String
	public let logoURL: URL?
	@CurrentValue var logo: UIImage? = nil
	
	enum LocalizationKey: String {
		case label = "network.label"
	}
	
	init(code: String, label: String, logoURL: URL?) {
		self.code = code
		self.label = label
		self.logoURL = logoURL
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
