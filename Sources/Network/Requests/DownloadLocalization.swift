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
struct DownloadLocalization: GetRequest {
    var url: URL
    let queryItems = [URLQueryItem]()
    typealias Response = [String: String]

    /// - Parameter url: `self` link from payment session
    init(from url: URL) {
        self.url = url
    }
}

@available(iOS 14.0, *)
extension DownloadLocalization {
    private var localizationName: String {
        url.lastPathComponent.replacingOccurrences(of: ".json", with: "")
    }

    func logRequest(to logger: Logger) {
        logger.info("[GET] ➡️ Localization for \(localizationName, privacy: .private)")
    }

    func logResponse(_ response: [String: String], to logger: Logger) {
        logger.info("[GET] ✅ Localization for \(localizationName, privacy: .private)")
    }
}
