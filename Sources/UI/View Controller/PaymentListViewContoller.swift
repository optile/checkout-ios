#if canImport(UIKit)
import UIKit

@objc public final class PaymentListViewContoller: UIViewController {
	weak var methodsTableView: UITableView?
	weak var activityIndicator: UIActivityIndicatorView?
	weak var errorAlertController: UIAlertController?
	
	let configuration: PaymentListParameters
	let sessionService: PaymentSessionService
	fileprivate(set) var tableController: PaymentListTableController?
	let localizationsProvider: SharedTranslationProvider
	
	/// - Parameter tableConfiguration: settings for a payment table view, if not specified defaults will be used
	/// - Parameter listResultURL: URL that you receive after executing *Create new payment session request* request. Needed URL will be specified in `links.self`
	@objc public convenience init(tableConfiguration: PaymentListParameters = DefaultPaymentListParameters(), listResultURL: URL) {
		let localizationsProvider = SharedTranslationProvider()
		let connection = URLSessionConnection()
		
		self.init(tableConfiguration: tableConfiguration, listResultURL: listResultURL, connection: connection, localizationsProvider: localizationsProvider)
	}
	
	init(tableConfiguration: PaymentListParameters, listResultURL: URL, connection: Connection, localizationsProvider: SharedTranslationProvider) {
		sessionService = PaymentSessionService(paymentSessionURL: listResultURL, connection: connection, localizationProvider: localizationsProvider)
		configuration = tableConfiguration
		self.localizationsProvider = localizationsProvider
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		// FIXME
		fatalError("init(coder:) has not been implemented")
	}
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.white

		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidPress))
		
		// FIXME: Localize
		title = "Payment method"
		
		load()
	}
	
	@objc private func cancelButtonDidPress() {
		dismiss(animated: true, completion: nil)
	}
		
	private func load() {
		sessionService.loadPaymentSession { session in
			DispatchQueue.main.async {
				self.changeState(to: session)
			}
		}
	}
}

// MARK: - View state management

extension PaymentListViewContoller {
	fileprivate func changeState(to state: Load<PaymentSession, PaymentError>) {
		switch state {
		case .success(let session):
			activityIndicator(isActive: false)
			showPaymentMethods(for: session)
			presentError(nil)
		case .loading:
			activityIndicator(isActive: true)
			showPaymentMethods(for: nil)
			presentError(nil)
		case .failure(let error):
			activityIndicator(isActive: true)
			showPaymentMethods(for: nil)
			presentError(error)
		}
	}
	
	private func showPaymentMethods(for session: PaymentSession?) {
		guard let session = session else {
			// Hide payment methods
			methodsTableView?.removeFromSuperview()
			methodsTableView = nil
			tableController = nil
			return
		}
		
		// Show payment methods
		let methodsTableView = self.addMethodsTableView()
		self.methodsTableView = methodsTableView
		
		let tableController = PaymentListTableController(session: session)
		tableController.tableView = methodsTableView
		tableController.loadLogo = sessionService.loadLogo
		self.tableController = tableController
		
		methodsTableView.dataSource = tableController
		methodsTableView.delegate = tableController
		methodsTableView.prefetchDataSource = tableController
	}
	
	private func activityIndicator(isActive: Bool) {
		if isActive == false {
			// Hide activity indicator
			activityIndicator?.stopAnimating()
			activityIndicator?.removeFromSuperview()
			activityIndicator = nil
			return
		}
		
		// Show activity indicator
		let activityIndicator = UIActivityIndicatorView(style: .gray)
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(activityIndicator)
		NSLayoutConstraint.activate([
			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
		self.activityIndicator = activityIndicator
		activityIndicator.startAnimating()
	}
	
	private func presentError(_ error: PaymentError?) {
		guard let error = error else {
			// Dismiss alert controller
			errorAlertController?.dismiss(animated: true, completion: nil)
			return
		}
		
		let controller = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
		
		// Add retry button if needed
		if error.underlyingError?.isNetworkError == true {
			let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
				self?.load()
			}
			controller.addAction(retryAction)
		}
		
		// Cancel
		let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { [weak self] _ in
			self?.dismiss(animated: true, completion: nil)
		}
		controller.addAction(cancelAction)
		
		self.present(controller, animated: true, completion: nil)
	}
}

// MARK: - Table View

extension PaymentListViewContoller {
	fileprivate func addMethodsTableView() -> UITableView {
		let methodsTableView = UITableView(frame: CGRect.zero, style: .grouped)
		
		configuration.customize?(tableView: methodsTableView)
		
		methodsTableView.translatesAutoresizingMaskIntoConstraints = false
		methodsTableView.register(PaymentListTableViewCell.self)
		view.addSubview(methodsTableView)
				
		NSLayoutConstraint.activate([
			methodsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			methodsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			methodsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			methodsTableView.topAnchor.constraint(equalTo: view.topAnchor)
		])
		
		return methodsTableView
	}
}
#endif
