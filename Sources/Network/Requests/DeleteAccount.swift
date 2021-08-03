// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation
import OSLog

// MARK: - Request

/// Delete all existing payment service provider registrations of selected registration type.
///
/// By default registration to delete is detected from `LIST` channel. Optionally de-registration instructions may be provided in the body of this request with following logic:
/// * If body is present
///    * and `deleteRegistration` is set to `true` then account registration is deleted
///    * and `deleteRecurrence` is set to `true` then recurring registration is deleted
/// * If body is absent
///    * and `LIST` channel is set to `RECURRING` then recurring registration is deleted
///    * and `LIST` channel is anything but `RECURRING` then account registration is deleted
///
/// - Note: The `LIST` session must been initialized with `updateOnly` option in order to allow this operation.
struct DeleteAccount: DeleteRequest {
    var url: URL
    let queryItems = [URLQueryItem]()

    /// Holds de-registration instructions about what types of registrations should be deleted. This information is optional and will be auto-detected based on channel if it isn't provided.
    var body: DeregistrationData?

    typealias Response = OperationResult

    /// - Parameter url: value from `links.accounts[X].self`
    init(url: URL, body: Body) {
        self.url = url
        self.body = body
    }
}

@available(iOS 14.0, *)
extension DeleteAccount {
    func logRequest(to logger: Logger) {
        logger.notice("[DELETE] ➡️ Delete registration using \(url, privacy: .private)")
    }

    func logResponse(_ response: OperationResult, to logger: Logger) {
        logger.notice("[DELETE] ✅ \(response.resultInfo, privacy: .public)")
    }
}
