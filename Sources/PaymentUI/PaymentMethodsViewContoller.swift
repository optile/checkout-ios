#if canImport(UIKit)

import UIKit
import Network

@objc public final class PaymentMethodsViewContoller: UIViewController {
	public weak var methodsTableView: UITableView!
	public var listResultURL: URL
	
	let tableBuilder: PaymentMethodsTableViewBuilder
	var sessionStore: PaymentSessionStore?
	
	/// - Parameter tableConfiguration: settings for a payment table view, if not specified defaults will be used
	/// - Parameter listResultURL: URL that you receive after executing *Create new payment session request* request. Needed URL will be specified in `links.self`
	public init(tableConfiguration: PaymentMethodsTableViewConfiguration = DefaultPaymentMethodsTableViewConfiguration(), listResultURL: URL) {
		self.tableBuilder = PaymentMethodsTableViewBuilder(configuration: tableConfiguration)
		self.listResultURL = listResultURL
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		// FIXME
		fatalError("init(coder:) has not been implemented")
	}
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		methodsTableView = tableBuilder.build()
		methodsTableView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(methodsTableView)
		layoutMethodsTableView()
	}
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableBuilder.load(listResult: listResultURL)
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
