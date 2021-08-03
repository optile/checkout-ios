// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation
import OSLog

// MARK: - Request

/// Gets active LIST session details
///
/// Retrieves available payment capabilities for active `LIST` session.
/// Response model is `
struct DownloadData: GetRequest {
    var url: URL
    let queryItems = [URLQueryItem]()
    typealias Response = Data

    /// - Parameter url: `self` link from payment session
    init(from url: URL) {
        self.url = url
    }
}

@available(iOS 14.0, *)
extension DownloadData {
    func logRequest(to logger: Logger) {
        logger.notice("[GET] ➡️ Download data from \(url, privacy: .public)")
    }

    func logResponse(_ response: Data, to logger: Logger) {
        logger.notice("[GET] ✅ OK")
    }
}
