// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation
import os.log

// MARK: - Constants

private extension String {
    static var httpVendorHeader: String { "application/vnd.optile.payment.enterprise-v1-extensible+json" }
}

// MARK: - SendRequestOperation

class SendRequestOperation<T>: AsynchronousOperation where T: Request {
    let connection: Connection
    let request: T
    var downloadCompletionBlock: ((Result<T.Response, Error>) -> Void)?

    private(set) var result: Result<T.Response, Error>?

    init(connection: Connection, request: T) {
        self.connection = connection
        self.request = request
        super.init()
    }

    override func main() {
        var urlRequest: URLRequest

        do {
            urlRequest = try request.build()
        } catch {
            self.finish(with: .failure(error))
            return
        }

        let userAgentValue = UserAgentBuilder().createUserAgentValue()
        urlRequest.addValue(userAgentValue, forHTTPHeaderField: "User-Agent")

        urlRequest.addValue(.httpVendorHeader, forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(.httpVendorHeader, forHTTPHeaderField: "Accept")

        if #available(iOS 14.0, *) {
            request.logRequest(to: request.logger)
        }

        connection.send(request: urlRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedResponse = try self.request.decodeResponse(with: data)
                    if #available(iOS 14.0, *) {
                        self.request.logResponse(decodedResponse, to: self.request.logger)
                    }
                    self.finish(with: .success(decodedResponse))
                } catch {
                    if #available(iOS 14.0, *) { self.log(error: error) }
                    self.finish(with: .failure(error))
                }
            case .failure(let error):
                if #available(iOS 14.0, *) { self.log(error: error) }
                self.finish(with: .failure(error))
            }
        }
    }

    @available(iOS 14.0, *)
    private func log(error: Error) {
        if let errorInfo = error as? ErrorInfo {
            request.logger.error("⛔️ \(errorInfo.resultInfo, privacy: .private). Interaction: \(errorInfo.interaction.code, privacy: .private)/\(errorInfo.interaction.reason, privacy: .private)")
        } else {
            request.logger.error("⛔️ \(error.localizedDescription, privacy: .private)")
        }
    }

    private func finish(with result: Result<T.Response, Error>) {
        self.result = result
        downloadCompletionBlock?(result)
        finish()
    }
}

@available(iOS 14.0, *)
private extension Request {
    var logger: Logger {
        Logger(subsystem: Bundle.frameworkIdentifier + ".network", category: String(describing: Self.self))
    }
}
