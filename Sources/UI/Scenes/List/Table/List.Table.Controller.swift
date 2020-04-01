#if canImport(UIKit)

import Foundation
import UIKit

protocol ListTableControllerDelegate: class {
    func didSelect(paymentNetworks: [PaymentNetwork])
    func didSelect(registeredAccount: RegisteredAccount)
    
    var downloadProvider: DataDownloadProvider { get }
}

extension List.Table {
    final class Controller: NSObject {
        weak var tableView: UITableView?
        weak var delegate: ListTableControllerDelegate?

        let dataSource: List.Table.DataSource
        
        init(session: PaymentSession, translationProvider: SharedTranslationProvider) throws {
            guard let genericLogo = AssetProvider.iconCard else {
                throw InternalError(description: "Unable to load a credit card's generic icon")
            }
            
            dataSource = .init(networks: session.networks, accounts: session.registeredAccounts, translation: translationProvider, genericLogo: genericLogo)
        }
        
        func viewDidLayoutSubviews() {
            guard let tableView = self.tableView else { return }
            for cell in tableView.visibleCells {
                guard let paymentCell = cell as? List.Table.BorderedCell else { continue }
                paymentCell.viewDidLayoutSubviews()
            }
        }

        fileprivate func loadLogo(for indexPath: IndexPath) {
            let models: [ContainsLoadableData]
            switch dataSource.model(for: indexPath) {
            case .account(let account): models = [account]
            case .network(let networks): models = networks
            }
            
            // Require array to have some not loaded logos, do nothing if everything is loaded
            guard !models.isFullyLoaded else { return }
            
            delegate?.downloadProvider.downloadData(for: models, completion: { [weak tableView] in
                DispatchQueue.main.async {
                    tableView?.reloadRows(at: [indexPath], with: .fade)
                }
            })
        }
    }
}


extension List.Table.Controller: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            loadLogo(for: indexPath)
        }
    }
}

extension List.Table.Controller: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadLogo(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataSource.model(for: indexPath) {
        case .account(let account): delegate?.didSelect(registeredAccount: account)
        case .network(let networks): delegate?.didSelect(paymentNetworks: networks)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = List.Table.SectionHeader(frame: .zero)
        view.textLabel?.text = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section)
        return view
    }
}
#endif

// MARK: - Loadable extension

private extension Sequence where Element == ContainsLoadableData {
    /// Is all elements in array loaded.
    /// - Note: if some elements were loaded but proccess was finished with error they count as _loaded_ element
    var isFullyLoaded: Bool {
        for element in self {
            if case .notLoaded = element.loadable { return false }
        }
        
        return true
    }
}
