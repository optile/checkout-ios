#if canImport(UIKit)
import UIKit

// MARK: Initializers

extension Input {
    class ViewController: SlideInViewController {
        let networks: [Network]
        
        private let tableController: Table.Controller
        private let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0), style: .plain)
        fileprivate let smartSwitch: SmartSwitch.Selector
        fileprivate let headerModel: ViewRepresentable?
        
        init(for paymentNetworks: [PaymentNetwork]) throws {
            let transfomer = Field.Transformer()
            networks = paymentNetworks.map { transfomer.transform(paymentNetwork: $0) }
            headerModel = nil
            smartSwitch = try .init(networks: self.networks)
            tableController = .init(for: smartSwitch.selected.network, tableView: tableView)
            
            super.init(nibName: nil, bundle: nil)
            
            self.scrollView = tableView
            
            tableController.inputChangesListener = self
            
            // Placeholder translation suffixer
            for field in transfomer.verificationCodeFields {
                field.keySuffixer = self
            }
        }
        
        init(for registeredAccount: RegisteredAccount) {
            let transfomer = Field.Transformer()
            let network = transfomer.transform(registeredAccount: registeredAccount)
            networks = [network]
            headerModel = Input.TextHeader(from: registeredAccount)
            smartSwitch = .init(network: network)
            tableController = .init(for: smartSwitch.selected.network, tableView: tableView)
            
            super.init(nibName: nil, bundle: nil)
            
            self.scrollView = tableView
            
            tableController.inputChangesListener = self
            
            // Placeholder translation suffixer
            for field in transfomer.verificationCodeFields {
                field.keySuffixer = self
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// MARK: - Overrides

extension Input.ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tintColor = .tintColor
        configure(tableView: tableView)
        
        tableView.layoutIfNeeded()
        setPreferredContentSize()
                
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: AssetProvider.iconClose, style: .plain, target: self, action: #selector(dismissView))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardFrameChangesObserver()
        
        tableController.becomeFirstResponder()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardFrameChangesObserver()
    }
}

extension Input.ViewController {
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - View configurator

extension Input.ViewController {
    fileprivate func configure(tableView: UITableView) {
        tableController.registerCells()
        
        tableView.dataSource = tableController
        tableView.delegate = tableController
        tableView.separatorStyle = .none
        tableView.tintColor = view.tintColor
        
        if #available(iOS 13.0, *) {
            tableView.backgroundColor = UIColor.systemBackground
        } else {
            tableView.backgroundColor = UIColor.white
        }

        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        // Table header
        if let model = headerModel {
            tableView.tableHeaderView = makeTableHeaderView(for: model)
        } else {
            tableView.tableHeaderView = nil
        }
    }
    
    private func makeTableHeaderView(for model: ViewRepresentable) -> UIView {
        let headerContentView = model.configurableViewType.init(frame: .zero)
        try? model.configure(view: headerContentView)
        
        let headerContentViewSize = headerContentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        headerContentView.frame = CGRect(origin: .zero, size: headerContentViewSize)
        
        let viewHeightWithSeparator = headerContentViewSize.height + Input.Table.SectionHeaderCell.Constant.height
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: viewHeightWithSeparator))
        headerView.preservesSuperviewLayoutMargins = true
        headerView.addSubview(headerContentView)
        NSLayoutConstraint.activate([
            headerContentView.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerContentView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            headerContentView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerContentView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor)
        ])
        
        return headerView
    }
}

// MARK: - InputValueChangesListener

extension Input.ViewController: InputValueChangesListener {
    /// Switch to a new network if needed (based on input field's type and value).
    /// - Note: called by `TableController`
    func valueDidChange(for field: InputField) {
        // React only on account number changes
        guard let accountNumberField = field as? Input.Field.AccountNumber else { return }
        
        let accountNumber = accountNumberField.value
        
        let previousSelection = smartSwitch.selected
        let newSelection = smartSwitch.select(usingAccountNumber: accountNumber)
        
        // Change UI only if the new network is not equal to current
        guard newSelection != previousSelection else { return }
                        
        DispatchQueue.main.async {
            // UI changes
            self.replaceCurrentNetwork(with: newSelection.network)
        }
    }
    
    private func replaceCurrentNetwork(with newNetwork: Input.Network) {
        tableController.network = newNetwork
    }
}

// MARK: - ModifableInsetsOnKeyboardFrameChanges

extension Input.ViewController: ModifableInsetsOnKeyboardFrameChanges {
    var scrollViewToModify: UIScrollView? { tableView }
    
    func willChangeKeyboardFrame(height: CGFloat, animationDuration: TimeInterval, animationOptions: UIView.AnimationOptions) {
         guard let scrollViewToModify = scrollViewToModify else { return }
        
         if navigationController?.modalPresentationStyle == .custom {
            scrollViewToModify.contentInset = .zero
            scrollViewToModify.scrollIndicatorInsets = .zero
            
            return
        }
        
         var adjustedHeight = height
         
         if let tabBarHeight = self.tabBarController?.tabBar.frame.height {
             adjustedHeight -= tabBarHeight
         } else if let toolbarHeight = navigationController?.toolbar.frame.height, navigationController?.isToolbarHidden == false {
             adjustedHeight -= toolbarHeight
         }
         
         if #available(iOS 11.0, *) {
             adjustedHeight -= view.safeAreaInsets.bottom
         }
         
         if adjustedHeight < 0 { adjustedHeight = 0 }
         
         UIView.animate(withDuration: animationDuration, animations: {
             let newInsets = UIEdgeInsets(top: 0, left: 0, bottom: adjustedHeight, right: 0)

             scrollViewToModify.contentInset = newInsets
             scrollViewToModify.scrollIndicatorInsets = newInsets
         })
     }
}

// MARK: - VerificationCodeTranslationKeySuffixer
extension Input.ViewController: VerificationCodeTranslationKeySuffixer {
    var suffixKey: String {
        switch smartSwitch.selected {
        case .generic: return "generic"
        case .specific: return "specific"
        }
    }
}
#endif
