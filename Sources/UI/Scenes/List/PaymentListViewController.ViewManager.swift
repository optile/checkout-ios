import UIKit

extension PaymentListViewController {
    /// Class responsible for views management: add, remove, configure appearance
    class ViewManager {
        var vc: PaymentListViewController!

        fileprivate var view: UIView { vc.view }
    }
}

extension PaymentListViewController.ViewManager {
    func configureMainView() {
        view.backgroundColor = .themedBackground
    }

    /// Add and activate an activity indicator
    func addActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        vc.activityIndicator = activityIndicator

        activityIndicator.startAnimating()
    }

    func removeActivityIndicator() {
        vc.activityIndicator?.stopAnimating()
        vc.activityIndicator?.removeFromSuperview()

        vc.activityIndicator = nil
    }
}

// MARK: - Table View UI

extension PaymentListViewController.ViewManager {
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
            scrollView.topAnchor.constraint(equalTo: view.topAnchor)
        ])

        return scrollView
    }

    @discardableResult
    /// Add methods UITableView to view and assign it to `self.methodsTableView`
    func addMethodsTableView() -> UITableView {
        let methodsTableView = List.Table.TableView(frame: CGRect.zero, style: .grouped)
        methodsTableView.separatorStyle = .none
        methodsTableView.backgroundColor = .clear
        methodsTableView.rowHeight = .rowHeight
        methodsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))

        methodsTableView.translatesAutoresizingMaskIntoConstraints = false
        methodsTableView.register(List.Table.SingleLabelCell.self)
        methodsTableView.register(List.Table.DetailedLabelCell.self)
        view.addSubview(methodsTableView)

        let topPadding: CGFloat = 30

        NSLayoutConstraint.activate([
            methodsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            methodsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            methodsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding)
        ])

        let trailingConstraint = methodsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        trailingConstraint.priority = .defaultHigh
        trailingConstraint.isActive = true

        vc.methodsTableView = methodsTableView

        return methodsTableView
    }
}
