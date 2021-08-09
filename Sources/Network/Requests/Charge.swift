// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation
import OSLog

// MARK: - Request

/// Request for `CHARGE` operation.
struct Charge: PostRequest {
    let url: URL
    let queryItems = [URLQueryItem]()
    var body: Body? { chargeBody }
    private let chargeBody: Body

    var operationType: String { url.lastPathComponent }

    typealias Response = OperationResult

    /// - Parameter url: value from `links.operation` for charge operation
    init(from url: URL, body: Body) {
        self.url = url
        self.chargeBody = body
    }
}

@available(iOS 14.0, *)
extension Charge {
    func logRequest(to logger: Logger) {
        logger.notice("[POST] ➡️ Charge request: \(url.absoluteString, privacy: .private)")
    }

    func logResponse(_ response: OperationResult, to logger: Logger) {
        logger.info("[POST] ✅ \(response.resultInfo, privacy: .private). Interaction: \(response.interaction.code, privacy: .private)/\(response.interaction.reason, privacy: .private)")
    }
}

// MARK: - Body

extension Charge {
    struct Body: Encodable {
        var account = [String: String]()
        var autoRegistration: Bool?
        var allowRecurrence: Bool?
        let browserData: BrowserData

        /// - Parameter inputFields: dictionary with input fields of `CHARGE` request
        init(inputFields: [String: String]) {
            for (name, value) in inputFields {
                switch name {
                case Input.Field.Checkbox.Constant.allowRegistration: autoRegistration = Bool(stringValue: value)
                case Input.Field.Checkbox.Constant.allowRecurrence: allowRecurrence = Bool(stringValue: value)
                default: account[name] = value
                }
            }

            self.browserData = BrowserDataBuilder.build()
        }
    }
}
