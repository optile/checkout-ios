// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

class PaymentRequest {
    /// Payment network code.
    let networkCode: String

    let operationURL: URL

    /// Textual dictionary with input fields.
    let inputFields: [String: String]

    let operationType: String

    internal init(networkCode: String, operationURL: URL, inputFields: [String: String]) {
        self.networkCode = networkCode
        self.operationURL = operationURL
        self.inputFields = inputFields
        self.operationType = operationURL.lastPathComponent.uppercased()
    }
}

extension PaymentRequest: OperationRequest {
    func send(using connection: Connection, completion: @escaping ((Result<OperationResult, Error>) -> Void)) {
        let chargeRequestBody = Charge.Body(inputFields: inputFields)
        let chargeRequest = Charge(from: operationURL, body: chargeRequestBody)
        let chargeOperation = SendRequestOperation(connection: connection, request: chargeRequest)
        chargeOperation.downloadCompletionBlock = completion
        chargeOperation.start()
    }
}
