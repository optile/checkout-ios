// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

extension Input.ViewController {
    class StateManager {
        unowned let vc: Input.ViewController

        var state: UIState = .inputFieldsPresentation {
            didSet { self.changeState(to: self.state, from: oldValue) }
        }

        init(viewController: Input.ViewController) {
            self.vc = viewController
        }
    }
}

extension Input.ViewController.StateManager {
    fileprivate func changeState(to newState: UIState, from oldState: UIState) {
        switch oldState {
        case .paymentSubmission:
            setEnabled(to: true)
            setPaymentSubmission(isActive: false)
        case .deletion:
            setEnabled(to: true)
            setDeletionActivityIndicator(to: .deleteButtonIsShown)
        default: break
        }

        switch newState {
        case .paymentSubmission:
            setEnabled(to: false)
            setPaymentSubmission(isActive: true)
        case .error(let error):
            present(error: error)
        case .deletion:
            setEnabled(to: false)
            setDeletionActivityIndicator(to: .activityIndicatorIsAnimating)
        default: break
        }
    }

    private func setEnabled(to isEnabled: Bool) {
        if #available(iOS 13.0, *) {
            vc.isModalInPresentation = !isEnabled
        }
        vc.navigationItem.leftBarButtonItem?.isEnabled = isEnabled
        vc.tableController.dataSource.setEnabled(isEnabled)
        vc.collectionView.reloadData()
    }

    private func setDeletionActivityIndicator(to state: RightBarButtonState) {
        let barButtonItem: UIBarButtonItem

        switch state {
        case .activityIndicatorIsAnimating:
            barButtonItem = UIBarButtonItem(customView: vc.activityIndicatorView)
            vc.activityIndicatorView.startAnimating()
        case .deleteButtonIsShown:
            barButtonItem = vc.deleteBarButton
        }

        vc.navigationItem.setRightBarButton(barButtonItem, animated: true)
    }

    private func setPaymentSubmission(isActive: Bool) {
        vc.tableController.dataSource.setPaymentButtonState(isLoading: isActive)
    }

    private func present(error: UIAlertController.AlertError) {
        let translator = vc.smartSwitch.selected.network.translation
        let alertController = error.createAlertController(translator: translator)

        vc.present(alertController, animated: true, completion: {
            self.state = .inputFieldsPresentation
        })
    }
}

extension Input.ViewController.StateManager {
    enum UIState {
        case inputFieldsPresentation
        case paymentSubmission
        case deletion
        case error(UIAlertController.AlertError)
    }

    fileprivate enum RightBarButtonState {
        case activityIndicatorIsAnimating
        case deleteButtonIsShown
    }
}
