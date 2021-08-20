// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation
import os.log

// MARK: - Request

/// Gets active LIST session details
///
/// Retrieves available payment capabilities for active `LIST` session.
struct GetListResult: GetRequest {
    var url: URL
    let queryItems = [URLQueryItem]()
    typealias Response = ListResult

    /// - Parameter url: `self` link from payment session
    init(url: URL) {
        self.url = url
    }
}

@available(iOS 14.0, *)
extension GetListResult {
    func logRequest(to logger: Logger) {
        logger.notice("[GET] ➡️ Payment session for \(url.lastPathComponent, privacy: .private(mask: .hash))")
    }

    func logResponse(_ response: ListResult, to logger: Logger) {
        logger.notice("[GET] ✅ \(response.resultInfo, privacy: .private)")
    }
}
