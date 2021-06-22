// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

protocol BodyEncodable {
    associatedtype Body
    var body: Body? { get }
    func encodeBody() throws -> Data?
}

extension BodyEncodable where Body: Encodable {
    func encodeBody() throws -> Data? {
        guard let body = self.body else { return nil }
        let encoder = JSONEncoder()
        return try encoder.encode(body)
    }
}
