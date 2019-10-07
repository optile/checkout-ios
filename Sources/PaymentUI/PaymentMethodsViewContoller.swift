#if canImport(UIKit)

import UIKit
import Network

@objc public final class PaymentMethodsViewContoller: UIViewController {
	public weak var methodsTableView: UITableView!
	
	let tableBuilder: PaymentMethodsTableViewBuilder
	var sessionStore: PaymentSessionStore?
	
	init(tableConfiguration: PaymentMethodsTableViewConfiguration = DefaultPaymentMethodsTableViewConfiguration()) {
		self.tableBuilder = PaymentMethodsTableViewBuilder(configuration: tableConfiguration)
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		// FIXME
		fatalError("init(coder:) has not been implemented")
	}
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		methodsTableView = tableBuilder.build()
		view.addSubview(methodsTableView)
		layoutMethodsTableView()
	}
	
	public func load(listResult: URL) {
		tableBuilder.load(listResult: listResult)
	}
	
	func layoutMethodsTableView() {
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
