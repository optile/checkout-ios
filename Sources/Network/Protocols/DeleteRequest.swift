// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

/// The `HTTP DELETE `method is used to delete a resource from the server.
protocol DeleteRequest: Request, BodyEncodable {}

extension DeleteRequest {
    var httpMethod: HTTPMethod { .DELETE }
}
