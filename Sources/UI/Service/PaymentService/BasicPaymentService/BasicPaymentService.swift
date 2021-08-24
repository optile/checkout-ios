// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation
import SafariServices

class BasicPaymentService: PaymentService {
    // MARK: - Static methods
    static func isSupported(networkCode: String, paymentMethod: String?) -> Bool {
        if let paymentMethod = paymentMethod {
            if isSupported(method: paymentMethod) { return true }
        }

        if isSupported(code: networkCode) { return true }

        return false
    }

    /// Find appropriate interaction code for specified operation type.
    static func getFailureInteractionCode(forOperationType operationType: String?) -> Interaction.Code {
        switch operationType {
        case "PRESET", "UPDATE", "ACTIVATION": return .ABORT
        default:
            // "CHARGE", "PAYOUT" and other operation types
            return .VERIFY
        }
    }

    private static func isSupported(method: String) -> Bool {
        let supportedMethods: [PaymentMethod] = [.DEBIT_CARD, .CREDIT_CARD]
        guard let paymentMethod = PaymentMethod(rawValue: method) else {
            return false
        }

        return supportedMethods.contains(paymentMethod)
    }

    private static func isSupported(code: String) -> Bool {
        let supportedCodes = ["SEPADD", "PAYPAL", "WECHATPC-R"]
        return supportedCodes.contains(code)
    }

    // MARK: -

    weak var delegate: PaymentServiceDelegate?

    let connection: Connection
    private var redirectCallbackHandler: RedirectCallbackHandler?
    private var responseParser: ResponseParser?

    required init(using connection: Connection) {
        self.connection = connection
    }

    func send(operationRequest: OperationRequest) {
        operationRequest.send(using: connection) { result in
            self.handle(response: result, for: operationRequest)
        }
    }

    private func handle(response: Result<OperationResult, Error>, for request: OperationRequest) {
        let parser = ResponseParser(operationType: request.operationType, connectionType: type(of: self.connection.self))
        let response = parser.parse(paymentRequestResponse: response)

        switch response {
        case .result: break
        case .redirect(let url):
            if #available(iOS 14.0, *) {
                logger.notice("Redirecting user to an external url: \(url.absoluteString, privacy: .private)")
            }

            let callbackHandler = RedirectCallbackHandler(for: request)
            callbackHandler.delegate = self.delegate
            callbackHandler.subscribeForNotification()

            self.redirectCallbackHandler = callbackHandler
        }

        self.delegate?.paymentService(didReceiveResponse: response, for: request)
    }
}

extension BasicPaymentService: Loggable {}
