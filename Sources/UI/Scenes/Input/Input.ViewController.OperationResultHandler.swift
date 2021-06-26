// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

// MARK: - Delegate

protocol InputPaymentControllerDelegate: AnyObject {
    func paymentController(presentURL url: URL)
    func paymentController(route result: Result<OperationResult, ErrorInfo>, for request: OperationRequest)
    func paymentController(inputShouldBeChanged error: ErrorInfo)

    /// Request is failed and error should be displayed
    /// - Parameters:
    ///   - request: could be `nil` if error was thrown before `OperationRequest` was created or sent
    func paymentController(didFailWith error: ErrorInfo, for request: OperationRequest?)
}

// MARK: - OperationResultHandler

extension Input.ViewController {
    class OperationResultHandler {
        weak var delegate: InputPaymentControllerDelegate?
    }
}

extension Input.ViewController.OperationResultHandler: PaymentServiceDelegate {
    func paymentService(didReceiveResponse response: PaymentServiceParsedResponse, for request: OperationRequest) {
        let serverResponse: Result<OperationResult, ErrorInfo>

        switch response {
        case .redirect(let url):
            DispatchQueue.main.async {
                self.delegate?.paymentController(presentURL: url)
            }
            return
        case .result(let result):
            serverResponse = result
        }

        // Handle internal `COMMUNICATION_FAILURE` error for all flows
        if case .COMMUNICATION_FAILURE = Interaction.Reason(rawValue: serverResponse.interaction.reason), case let .failure(errorInfo) = serverResponse {
            DispatchQueue.main.async {
                self.delegate?.paymentController(didFailWith: errorInfo, for: request)
            }
            return
        }

        // Handlers for each flow
        switch request {
        case let chargeRequest as PaymentRequest:
            handle(response: serverResponse, for: chargeRequest)
        case let deletionRequest as DeletionRequest:
            handle(response: serverResponse, for: deletionRequest)
        default:
            let internalError = InternalError(description: "Unexpected request type, programmatic error")
            let errorInfo = CustomErrorInfo.createClientSideError(from: internalError)
            delegate?.paymentController(route: .failure(errorInfo), for: request)
        }
    }
}

// MARK: Handler for `PaymentRequest`

extension Input.ViewController.OperationResultHandler {
    func handle(response: Result<OperationResult, ErrorInfo>, for request: PaymentRequest) {
        // On retry show an error and leave on that view
        if case .RETRY = Interaction.Code(rawValue: response.interaction.code) {
            let errorInfo = ErrorInfo(resultInfo: response.resultInfo, interaction: response.interaction)

            DispatchQueue.main.async {
                self.delegate?.paymentController(inputShouldBeChanged: errorInfo)
            }
        }

        // In other situations route to a parent view
        else {
            DispatchQueue.main.async {
                self.delegate?.paymentController(route: response, for: request)
            }
        }
    }
}

// MARK: Handler for `DeletionRequest`

extension Input.ViewController.OperationResultHandler {
    func handle(response: Result<OperationResult, ErrorInfo>, for request: DeletionRequest) {
        // On retry show an error and leave on that view
        if case .RETRY = Interaction.Code(rawValue: response.interaction.code) {
            let errorInfo = ErrorInfo(resultInfo: response.resultInfo, interaction: response.interaction)

            DispatchQueue.main.async {
                self.delegate?.paymentController(inputShouldBeChanged: errorInfo)
            }
        }

        // In other situations route to a parent view
        else {
            DispatchQueue.main.async {
                self.delegate?.paymentController(route: response, for: request)
            }
        }
    }
}
