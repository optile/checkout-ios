import Foundation

#if canImport(UIKit)
import UIKit
#endif

public struct PaymentNetwork {
	public let label: String
	public let logoURL: URL?
	
	#if canImport(UIKit)
	public let logo: UIImage?
	#endif
}
