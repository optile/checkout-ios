import Foundation

#if canImport(UIKit)
import UIKit
#endif

public struct PaymentNetwork {
	public let label: String
	public let logoURL: URL?
	
	#if canImport(UIKit)
	private(set) public var logo: ObservableObject<Loadable<UIImage>?> = nil
	#endif
}
