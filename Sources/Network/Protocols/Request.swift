// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation
import os.log

/// Base request protocol that will be used for `Connection`.
protocol Request {
    associatedtype Response

    /// Value for this property will always override query items from the `url`
    var queryItems: [URLQueryItem] { get }
    var url: URL { get }

    func decodeResponse(with data: Data?) throws -> Response
    func build() throws -> URLRequest

    var httpMethod: HTTPMethod { get }

    // Logging

    @available(iOS 14.0, *)
    func logRequest(to logger: Logger)

    @available(iOS 14.0, *)
    func logResponse(_ response: Response, to logger: Logger)
}

extension Request where Response == Data {
    func decodeResponse(with data: Data?) throws -> Response {
        guard let data = data else {
            let error = InternalError(description: "Server returned no data")
            throw error
        }

        return data
    }
}

extension Request where Response: Decodable {
    func decodeResponse(with data: Data?) throws -> Response {
        guard let data = data else {
            let error = InternalError(description: "Server returned no data")
            throw error
        }

        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

extension Request where Response == Void {
    func decodeResponse(with data: Data?) throws -> Response {
        return Void()
    }
}

fileprivate extension Request {
    /// Generic URL request containing only URL and QueryItems
    func buildGenericRequest() throws -> URLRequest {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw InternalError(description: "Internal error, incorrect PostRequest URL: %@", url.absoluteString)
        }

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw InternalError(description: "Internal error, unable to create API request URL from URLComponents")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue

        return urlRequest
    }
}

extension Request {
    func build() throws -> URLRequest {
        return try buildGenericRequest()
    }
}

extension Request where Self: BodyEncodable {
    func build() throws -> URLRequest {
        var request = try buildGenericRequest()
        request.httpBody = try encodeBody()
        return request
    }
}
