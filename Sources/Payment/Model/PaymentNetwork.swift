import Foundation

#if canImport(UIKit)
import UIKit
#endif

public class PaymentNetwork {
	public let label: String
	public let logoURL: URL?
	
	#if canImport(UIKit)
	@CurrentValue private(set) public var logo: Load<UIImage>?
	#endif
	
	public init(label: String, logoURL: URL?) {
		self.label = label
		self.logoURL = logoURL
	}
}
