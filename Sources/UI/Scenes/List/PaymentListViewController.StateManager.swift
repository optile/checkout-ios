import UIKit

extension PaymentListViewController {
    class StateManager {
        weak var vc: PaymentListViewController!

        fileprivate var tableController: List.Table.Controller?

        var viewState: Load<PaymentSession, UIAlertController.AlertError> = .loading {
            didSet { changeState(to: viewState) }
        }
    }
}

extension PaymentListViewController.StateManager {
    fileprivate func changeState(to state: Load<PaymentSession, UIAlertController.AlertError>) {
        switch state {
        case .success(let session):
            do {
                activityIndicator(isActive: false)
                try showPaymentMethods(for: session)
                dismissAlertController()
            } catch {
                let errorInfo = CustomErrorInfo.createClientSideError(from: error)
                vc.dismiss(with: .failure(errorInfo))
            }
        case .loading:
            do {
                activityIndicator(isActive: true)
                try showPaymentMethods(for: nil)
                dismissAlertController()
            } catch {
                let errorInfo = CustomErrorInfo.createClientSideError(from: error)
                vc.dismiss(with: .failure(errorInfo))
           }
        case .failure(let error):
            activityIndicator(isActive: true)
            try? showPaymentMethods(for: nil)
            vc.present(error: error)
        }
    }

    private func showPaymentMethods(for session: PaymentSession?) throws {
        guard let session = session else {
            // Hide payment methods
            vc.methodsTableView?.removeFromSuperview()
            vc.methodsTableView = nil
            tableController = nil

            return
        }

        // Show payment methods
        let methodsTableView = vc.addMethodsTableView()

        let tableController = try List.Table.Controller(session: session, translationProvider: vc.sharedTranslationProvider)
        tableController.tableView = methodsTableView
        tableController.delegate = vc
        self.tableController = tableController

        methodsTableView.dataSource = tableController.dataSource
        methodsTableView.delegate = tableController
        methodsTableView.prefetchDataSource = tableController

        methodsTableView.invalidateIntrinsicContentSize()
    }

    private func activityIndicator(isActive: Bool) {
        if isActive == false {
            // Hide activity indicator
            vc.removeActivityIndicator()
            return
        }

        if vc.activityIndicator != nil { return }

        vc.addActivityIndicator()
    }

    private func dismissAlertController() {
        vc.errorAlertController?.dismiss(animated: true, completion: nil)
    }
}
