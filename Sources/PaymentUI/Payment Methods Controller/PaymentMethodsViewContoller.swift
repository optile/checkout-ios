#if canImport(UIKit)

import UIKit
import Network

@objc public final class PaymentMethodsViewContoller: UIViewController {
	weak var methodsTableView: UITableView?
	weak var activityIndicator: UIActivityIndicatorView?
	weak var errorAlertController: UIAlertController?
	
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
		view.backgroundColor = UIColor.white
		
		// FIXME: Localize
		title = "Payment method"
		
		load(listResult: listResultURL)
	}
		
	private func load(listResult: URL) {
		let store = PaymentSessionStore(paymentSessionURL: listResult)
		self.sessionStore = store
		
		store.$sessionState.subscribe { [weak self] (_, sessionState) in
			DispatchQueue.main.async {
				self?.viewSessionState = sessionState
			}
		}
		
		store.loadPaymentSession()
	}
	
	var viewSessionState: Load<PaymentSession> = .inactive {
		didSet {
			switch viewSessionState {
			case .success(let session):
				isActivityIndicatorActive = false
				showingPaymentMethods = session
				showingError = nil
			case .loading:
				isActivityIndicatorActive = true
				showingPaymentMethods = nil
				showingError = nil
			case .failure(let error):
				isActivityIndicatorActive = true
				showingPaymentMethods = nil
				showingError = error
			default: return
			}
		}
	}
}

// MARK: - View state management

extension PaymentMethodsViewContoller {
	fileprivate var showingPaymentMethods: PaymentSession? {
		get {
			if case .success(let session) = viewSessionState {
				return session
			}
			
			return nil
		}
		
		set {
			guard let session = newValue else {
				// Hide payment methods
				methodsTableView?.removeFromSuperview()
				methodsTableView = nil
				return
			}
			
			// Show payment methods
			let methodsTableView = self.addMethodsTableView()
			self.methodsTableView = methodsTableView
			
			// FIXME: Localize
			let group = PaymentMethodsTableViewResultsController.TableGroup(groupName: "Choose a method")
			group.networks = session.networks
			resultsController.dataSource = [group]
		}
	}
	
	fileprivate var isActivityIndicatorActive: Bool {
		get {
			return (activityIndicator != nil)
		}
		
		set {
			if newValue == false {
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
	}
	
	fileprivate var showingError: Error? {
		get {
			if case .failure(let error) = viewSessionState {
				return error
			}
			
			return nil
		}
		set {
			guard let error = newValue else {
				// Dismiss alert controller
				errorAlertController?.dismiss(animated: true, completion: nil)
				return
			}
			
			// Show alert
			let controller = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
			
			let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
				guard let weakSelf = self else { return }
				weakSelf.load(listResult: weakSelf.listResultURL)
				self?.showingError = nil
			}
			controller.addAction(retryAction)
			
			let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
				self?.dismiss(animated: true, completion: nil)
			}
			controller.addAction(cancelAction)
			
			self.present(controller, animated: true, completion: nil)
		}
	}
}

// MARK: - Table View

extension PaymentMethodsViewContoller {
	fileprivate func addMethodsTableView() -> UITableView {
		let methodsTableView = UITableView(frame: CGRect.zero, style: .grouped)
		
		configuration.customize?(tableView: methodsTableView)
		
		methodsTableView.translatesAutoresizingMaskIntoConstraints = false
		methodsTableView.register(PaymentMethodsTableViewCell.self)
		methodsTableView.dataSource = resultsController
		view.addSubview(methodsTableView)
		resultsController.tableView = methodsTableView
		
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
