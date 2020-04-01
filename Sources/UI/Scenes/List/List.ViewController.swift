#if canImport(UIKit)
import UIKit

extension List {
    @objc public final class ViewController: UIViewController {
        weak var scrollView: UIScrollView?
        weak var methodsTableView: UITableView?
        weak var activityIndicator: UIActivityIndicatorView?
        weak var errorAlertController: UIAlertController?

        let configuration: PaymentListParameters
        let sessionService: PaymentSessionService
        fileprivate(set) var tableController: List.Table.Controller?
        let sharedTranslationProvider: SharedTranslationProvider
        
        lazy private(set) var slideInPresentationManager = SlideInPresentationManager()

        /// - Parameter tableConfiguration: settings for a payment table view, if not specified defaults will be used
        /// - Parameter listResultURL: URL that you receive after executing *Create new payment session request* request. Needed URL will be specified in `links.self`
        @objc public convenience init(tableConfiguration: PaymentListParameters = DefaultPaymentListParameters(), listResultURL: URL) {
            let sharedTranslationProvider = SharedTranslationProvider()
            let connection = URLSessionConnection()

            self.init(tableConfiguration: tableConfiguration, listResultURL: listResultURL, connection: connection, sharedTranslationProvider: sharedTranslationProvider)
        }

        init(tableConfiguration: PaymentListParameters, listResultURL: URL, connection: Connection, sharedTranslationProvider: SharedTranslationProvider) {
            sessionService = PaymentSessionService(paymentSessionURL: listResultURL, connection: connection, localizationProvider: sharedTranslationProvider)
            configuration = tableConfiguration
            self.sharedTranslationProvider = sharedTranslationProvider
            
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension List.ViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        // If view was presented modally show Cancel button
        if navigationController == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidPress))
        }

        load()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableController?.viewDidLayoutSubviews()
    }
    
    public override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        methodsTableView?.reloadData()
    }

    @objc private func cancelButtonDidPress() {
        dismiss(animated: true, completion: nil)
    }

    private func load() {
        sessionService.loadPaymentSession(
            loadDidComplete: { [weak self]  session in
                DispatchQueue.main.async {
                    self?.title = self?.sharedTranslationProvider.translation(forKey: LocalTranslation.listTitle.rawValue)
                    self?.changeState(to: session)
                }
            },
            shouldSelect: { [weak self] network in
                DispatchQueue.main.async {
                    self?.show(paymentNetworks: [network], animated: false)
                }
            }
        )
    }
    
    fileprivate func show(paymentNetworks: [PaymentNetwork], animated: Bool) {
        do {
            let inputViewController = try Input.ViewController(for: paymentNetworks)
            let navigationController = UINavigationController(rootViewController: inputViewController)
            present(navigationController, animated: animated, completion: nil)
        } catch {
            changeState(to: .failure(error))
        }
    }
    
    fileprivate func show(registeredAccount: RegisteredAccount, animated: Bool) {
        let inputViewController = Input.ViewController(for: registeredAccount)
        let navigationController = Input.NavigationController(rootViewController: inputViewController)
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = slideInPresentationManager
        present(navigationController, animated: animated, completion: nil)
    }
}

// MARK: - View state management

extension List.ViewController {
    fileprivate func changeState(to state: Load<PaymentSession, Error>) {
        switch state {
        case .success(let session):
            do {
                activityIndicator(isActive: false)
                try showPaymentMethods(for: session)
                presentError(nil)
            } catch {
                changeState(to: .failure(error))
            }
        case .loading:
            do {
                activityIndicator(isActive: true)
                try showPaymentMethods(for: nil)
                presentError(nil)
            } catch {
               changeState(to: .failure(error))
           }
        case .failure(let error):
            do {
                activityIndicator(isActive: true)
                try showPaymentMethods(for: nil)
                presentError(error)
            } catch {
                changeState(to: .failure(error))
            }
        }
    }

    private func showPaymentMethods(for session: PaymentSession?) throws {
        guard let session = session else {
            // Hide payment methods
            scrollView?.removeFromSuperview()
            scrollView = nil
            
            methodsTableView?.removeFromSuperview()
            methodsTableView = nil
            tableController = nil
            
            return
        }

        // Show payment methods
        let scrollView = addScrollView()
        self.scrollView = scrollView
        
        let methodsTableView = addMethodsTableView(to: scrollView)
        self.methodsTableView = methodsTableView

        let tableController = try List.Table.Controller(session: session, translationProvider: sharedTranslationProvider)
        tableController.tableView = methodsTableView
        tableController.delegate = self
        self.tableController = tableController

        methodsTableView.dataSource = tableController.dataSource
        methodsTableView.delegate = tableController
        methodsTableView.prefetchDataSource = tableController
        
        methodsTableView.invalidateIntrinsicContentSize()
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

    private func presentError(_ error: Error?) {
        guard let error = error else {
            // Dismiss alert controller
            errorAlertController?.dismiss(animated: true, completion: nil)
            return
        }
        
        let localizedError: LocalizedError
        if let error = error as? LocalizedError {
            localizedError = error
        } else {
            localizedError = PaymentError(localizedDescription: LocalTranslation.errorDefault.localizedString, underlyingError: nil)
        }

        let controller = UIAlertController(title: localizedError.localizedDescription, message: nil, preferredStyle: .alert)

        // Add retry button if needed
        if let networkError = error.asNetworkError {
            controller.title = networkError.localizedDescription
            let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
                self?.load()
            }
            controller.addAction(retryAction)
        }

        // Cancel
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { [weak self] _ in
            // Dimiss or pop back on error
            if self?.navigationController == nil {
                self?.dismiss(animated: true, completion: nil)
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        controller.addAction(cancelAction)

        self.present(controller, animated: true, completion: nil)
    }
}

// MARK: - Table View UI

extension List.ViewController {
    fileprivate func addScrollView() -> UIScrollView {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.alwaysBounceVertical = true
        scrollView.preservesSuperviewLayoutMargins = true
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        
        return scrollView
    }
    
    fileprivate func addMethodsTableView(to superview: UIView) -> UITableView {
        let methodsTableView = List.Table.TableView(frame: CGRect.zero, style: .grouped)
        methodsTableView.separatorStyle = .none
        methodsTableView.backgroundColor = .clear
        methodsTableView.rowHeight = .rowHeight
        
        if #available(iOS 11.0, *) {
            methodsTableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        // Use that to remove extra spacing at top
        methodsTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        
        methodsTableView.isScrollEnabled = false
        
        configuration.customize?(tableView: methodsTableView)

        methodsTableView.translatesAutoresizingMaskIntoConstraints = false
        methodsTableView.register(List.Table.SingleLabelCell.self)
        methodsTableView.register(List.Table.DetailedLabelCell.self)
        superview.addSubview(methodsTableView)

        let topPadding: CGFloat = 30
        
        NSLayoutConstraint.activate([
            methodsTableView.leadingAnchor.constraint(equalTo: superview.layoutMarginsGuide.leadingAnchor),
            methodsTableView.bottomAnchor.constraint(equalTo: superview.layoutMarginsGuide.bottomAnchor),
            methodsTableView.topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor, constant: topPadding),
            methodsTableView.centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        ])
        
        let trailingConstraint = methodsTableView.trailingAnchor.constraint(equalTo: superview.layoutMarginsGuide.trailingAnchor)
        trailingConstraint.priority = .defaultHigh
        trailingConstraint.isActive = true

        return methodsTableView
    }
}

extension List.ViewController: ListTableControllerDelegate {
    var downloadProvider: DataDownloadProvider { sessionService.downloadProvider }
    
    func didSelect(paymentNetworks: [PaymentNetwork]) {
        show(paymentNetworks: paymentNetworks, animated: true)
    }
    
    func didSelect(registeredAccount: RegisteredAccount) {
        show(registeredAccount: registeredAccount, animated: true)
    }
}

extension CGFloat {
    static var rowHeight: CGFloat { return 64 }
}
#endif
