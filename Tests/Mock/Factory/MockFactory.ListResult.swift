// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation
@testable import PayoneerCheckout

extension MockFactory {
    class ListResult {
        private init() {}
    }
}

extension MockFactory.ListResult {
    static var paymentSession: PaymentSession {
        let listResult = try! JSONDecoder().decode(PayoneerCheckout.ListResult.self, from: listResultData)

        let translatedNetworks = listResult.networks.applicable.map {
            TranslatedModel(model: $0, translator: MockFactory.Localization.provider)
        }

        return PaymentSession(operationType: "CHARGE", networks: translatedNetworks, accounts: nil)
    }

    static var listResultData: Data {
        let bundle = Bundle(for: MockFactory.ListResult.self)
        let url = bundle.url(forResource: "ListResult", withExtension: "json")!
        let jsonData = try! Data(contentsOf: url)
        return jsonData
    }
}
