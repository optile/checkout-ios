import Foundation

public struct PaymentNetwork {
	public let label: String
	public let logoURL: URL?
	public var logoData: Data? = nil
	
	enum LocalizationKey: String {
		case label = "network.label"
	}
}
