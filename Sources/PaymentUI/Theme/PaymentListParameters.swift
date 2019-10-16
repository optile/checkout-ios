#if canImport(UIKit)

import UIKit

@objc public protocol PaymentListParameters {
	
	/// Use for other customization options
	///
	/// - Warning: Don't modify delegate and data source properties
	/// - Parameter tableView: table view with a list of available payment methods
	@objc optional func customize(tableView: UITableView)
}

@objc public class DefaultPaymentListParameters: NSObject, PaymentListParameters {
}

#endif
