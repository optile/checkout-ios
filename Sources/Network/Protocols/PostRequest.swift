// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

/// Simple request that just performs `POST` request on specified URL.
protocol PostRequest: Request, BodyEncodable {}

extension PostRequest {
    var httpMethod: HTTPMethod { .POST }
}

extension PostRequest {

}
