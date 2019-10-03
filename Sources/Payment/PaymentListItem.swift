import Foundation

public protocol PaymentListItem {
	var label: String { get }
	var logoData: Data { get }
}

#if canImport(UIKit)
import UIKit

public extension PaymentListItem {
	var logo: UIImage {
		return UIIm
	}
}
#endif
