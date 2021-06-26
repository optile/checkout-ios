// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

extension Input.ViewController {
    class PaymentController {
        let paymentServiceFactory: PaymentServicesFactory
        let operationResultHandler = OperationResultHandler()

        weak var delegate: InputPaymentControllerDelegate?

        init(paymentServiceFactory: PaymentServicesFactory) {
            self.paymentServiceFactory = paymentServiceFactory
        }
    }
}

extension Input.ViewController.PaymentController {
    func delete(network: Input.Network) {
        let service = paymentServiceFactory.createPaymentService(forNetworkCode: network.networkCode, paymentMethod: network.paymentMethod)
        service?.delegate = operationResultHandler

        guard let selfLink = network.apiModel.links?["self"] else {
            let error = InternalError(description: "API model doesn't contain links.self property")
            let errorInfo = CustomErrorInfo.createClientSideError(from: error)
            delegate?.paymentController(didFailWith: errorInfo, for: nil)
            return
        }

        let request = DeletionRequest(accountURL: selfLink, operationType: network.apiModel.operationType)
        service?.send(operationRequest: request)
    }

    func submitPayment(for network: Input.Network) {
        let service = paymentServiceFactory.createPaymentService(forNetworkCode: network.networkCode, paymentMethod: network.paymentMethod)
        service?.delegate = operationResultHandler

        let inputFieldsDictionary: [String: String]
        do {
            inputFieldsDictionary = try createInputFields(from: network)
        } catch {
            let errorInfo = CustomErrorInfo(resultInfo: error.localizedDescription, interaction: Interaction(code: .ABORT, reason: .CLIENTSIDE_ERROR), underlyingError: error)
            delegate?.paymentController(didFailWith: errorInfo, for: nil)
            return
        }

        let request = PaymentRequest(networkCode: network.networkCode, operationURL: network.operationURL, inputFields: inputFieldsDictionary)

        service?.send(operationRequest: request)
    }

    private func createInputFields(from network: Input.Network) throws -> [String: String] {
        var inputFieldsDictionary = [String: String]()
        for element in network.uiModel.inputFields + network.uiModel.separatedCheckboxes {
            if element.name == "expiryDate" {
                // Transform expiryDate to month and a full year
                let dateComponents = try createDateComponents(fromExpiryDateString: element.value)
                inputFieldsDictionary["expiryMonth"] = dateComponents.month
                inputFieldsDictionary["expiryYear"] = dateComponents.year
            } else {
                inputFieldsDictionary[element.name] = element.value
            }
        }

        return inputFieldsDictionary
    }

    /// Create month and full year for short date string
    /// - Parameter expiryDate: example `03/30`
    /// - Returns: month and full year
    private func createDateComponents(fromExpiryDateString expiryDate: String) throws -> (month: String, year: String) {
        let expiryMonth = String(expiryDate.prefix(2))
        let shortYear = String(expiryDate.suffix(2))
        let expiryYear = try DateFormatter.string(fromShortYear: shortYear)
        return (month: expiryMonth, year: expiryYear)
    }
}

private extension Input.Network.APIModel {
    var links: [String: URL]? {
        switch self {
        case .account(let account): return account.links
        case .network(let network): return network.links
        }
    }

    var operationType: String {
        switch self {
        case .account(let account): return account.operationType
        case .network(let network): return network.operationType
        }
    }
}
