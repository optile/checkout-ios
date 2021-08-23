// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation
import os.log

class URLSessionConnection: Connection {
    let session = URLSession(configuration: URLSessionConfiguration.default)

    typealias RequestCompletionHandler = (Result<Data?, Error>) -> Void

    func send(request: URLRequest, completionHandler: @escaping ((Result<Data?, Error>) -> Void)) {
        // Send a network request
        let task = session.dataTask(with: request) { [handleDataTaskResponse] (data, response, error) in
            handleDataTaskResponse(data, response, error, completionHandler)
        }

        task.resume()
    }

    // MARK: - Helper methods

    private func handleDataTaskResponse(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping RequestCompletionHandler) {
        // HTTP Errors
        if let error = error {
            completionHandler(.failure(error))
            return
        }

        guard let response = response else {
            let error = InternalError(description: "Incorrect completion from a URLSession, we have no error and no response")
            completionHandler(.failure(error))
            return
        }

        // We expect HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            let error = InternalError(description: "Unexpected server response (receive a non-HTTP response)")
            completionHandler(.failure(error))
            return
        }

        // - TODO: Read more about backend's status codes
        guard httpResponse.statusCode >= 200, httpResponse.statusCode < 400 else {
            if let data = data, let backendError = try? JSONDecoder().decode(ErrorInfo.self, from: data) {
                completionHandler(.failure(backendError))
            } else {
                let error = InternalError(description: "Non-OK response from a server")
                completionHandler(.failure(error))
            }

            return
        }

        completionHandler(.success(data))
    }
}

extension URLSessionConnection {
    // Is error could be potentially recovered (if it is a network error in that case)
    static func isRecoverableError(_ error: Error) -> Bool {
        let nsError = error as NSError
        return nsError.domain == NSURLErrorDomain
    }
}
