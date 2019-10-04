import Foundation

#if canImport(UIKit)
import UIKit
#endif

public struct PaymentNetwork {
	public let label: String
	public let logoURL: URL?
	
	#if canImport(UIKit)
	private(set) public var logoState: LoadableState<UIImage>?
	public var logoStateDidChange: ((LoadableState<UIImage>) -> Void)?
	
	func setLogoState(_ logo: LoadableState<UIImage>) {
		self.logo = logo
		logoStateDidChange?(logo)
	}
	#endif
	
	init(label: String) {
		self.label = label
		self.logoURL = nil
		
		#if canImport(UIKit)
		self.logo = nil
		#endif
	}
}
