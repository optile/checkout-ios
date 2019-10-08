#if canImport(UIKit)

import UIKit
import Network

@objc public final class PaymentMethodsViewContoller: UIViewController {
	public weak var methodsTableView: UITableView!
	public var listResultURL: URL
	
	let configuration: PaymentMethodsTableViewConfiguration
	let resultsController = PaymentMethodsTableViewResultsController()
	var sessionStore: PaymentSessionStore?
	
	/// - Parameter tableConfiguration: settings for a payment table view, if not specified defaults will be used
	/// - Parameter listResultURL: URL that you receive after executing *Create new payment session request* request. Needed URL will be specified in `links.self`
	public init(tableConfiguration: PaymentMethodsTableViewConfiguration = DefaultPaymentMethodsTableViewConfiguration(), listResultURL: URL) {
		self.configuration = tableConfiguration
		self.listResultURL = listResultURL
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		// FIXME
		fatalError("init(coder:) has not been implemented")
	}
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	private func load(listResult: URL) {
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
	
	// MARK: - Table View
	
	private func createMethodsTableView() -> UITableView {
		let methodsTableView = UITableView(frame: CGRect.zero, style: .plain)
		
		configuration.customize?(tableView: methodsTableView)
		
		methodsTableView.translatesAutoresizingMaskIntoConstraints = false
		methodsTableView.register(PaymentMethodsTableViewCell.self)
		methodsTableView.dataSource = resultsController
		view.addSubview(methodsTableView)
		layoutMethodsTableView(methodsTableView)
		resultsController.tableView = methodsTableView
		
		return methodsTableView
	}
	
	private func layoutMethodsTableView(_ methodsTableView: UITableView) {
		NSLayoutConstraint.activate([
			methodsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			methodsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		])
		
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				methodsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
				methodsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
			])
		} else {
			NSLayoutConstraint.activate([
				methodsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				methodsTableView.topAnchor.constraint(equalTo: view.topAnchor)
			])
		}
	}
}

#endif
