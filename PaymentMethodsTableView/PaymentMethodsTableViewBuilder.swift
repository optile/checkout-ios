#if canImport(UIKit)
import Foundation
import UIKit

@objc public class PaymentMethodsTableViewBuilder: NSObject {
	public var configuration: PaymentMethodsTableViewConfiguration
	
	let resultsController = PaymentMethodsTableViewResultsController()
	let tableView = UITableView(frame: CGRect.zero, style: .plain)
	var sessionStore: PaymentSessionStore?
	
	public init(configuration: PaymentMethodsTableViewConfiguration = DefaultPaymentMethodsTableViewConfiguration()) {
		self.configuration = configuration
		super.init()
	}
	
	public func load(listResult: URL) {
		let store = PaymentSessionStore(paymentSessionURL: listResult)
		self.sessionStore = store
		store.$session.subscribe { [weak resultsController] sessionState in
			switch sessionState {
			case .success(let session):
				let group = PaymentMethodsTableViewResultsController.TableGroup(groupName: "Choose a method (localization required")
				group.networks = session.networks
				resultsController?.dataSource = [group]
				fallthrough
			default: dump(sessionState)
			}
		}
		store.loadPaymentSession()
	}
	
	public func build() -> UITableView {
		tableView.dataSource = resultsController
		tableView.register(PaymentMethodsTableViewCell.self)
		resultsController.tableView = tableView
		configuration.customize?(tableView: tableView)
		return tableView
	}
}

#endif
