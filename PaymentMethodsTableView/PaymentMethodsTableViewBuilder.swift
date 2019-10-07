#if canImport(UIKit)
import Foundation
import UIKit

@objc public class PaymentMethodsTableViewBuilder: NSObject {
	public var configuration: PaymentMethodsTableViewConfiguration
	let dataSource = PaymentMethodsTableViewResultsController()
	
	public init(configuration: PaymentMethodsTableViewConfiguration = DefaultPaymentMethodsTableViewConfiguration()) {
		self.configuration = configuration
		super.init()
	}
	
	public func load(listResult: URL) {
		let store = PaymentSessionStore(paymentSessionURL: listResult)
		store.loadPaymentSession()
	}
	
	public func build() -> UITableView {
		let tableView = UITableView(frame: CGRect.zero, style: .plain)
		tableView.register(PaymentMethodsTableViewCell.self)
		dataSource.tableView = tableView
		
		configuration.customize?(tableView: tableView)
		return tableView
	}
}

#endif
