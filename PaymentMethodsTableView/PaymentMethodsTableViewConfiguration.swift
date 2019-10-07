import Foundation

@objc public protocol PaymentMethodsTableViewConfiguration {
	
	/// Use for other customization options
	///
	/// - Warning: Don't modify delegate and data source properties
	/// - Parameter tableView: table view with a list of available payment methods
	@objc optional func customize(tableView: UITableView)
}

@objc public class DefaultPaymentMethodsTableViewConfiguration: NSObject, PaymentMethodsTableViewConfiguration {
}
