// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

struct Transaction: Codable {
    var integration: String?

    /// Identifier for this transaction given by the merchant. It is not validated for uniqueness by OPG, but may be checked for by some PSPs, thus recommended to be unique.
    var transactionId: String

    /// Country where the payment is originating. This influences the choice of the available payment networks. Value format is according to ISO 3166-1 (alpha-2), e.g. "DE", "FR", "US", "GB", etc.
    var country: String

    var callback: Callback
    var customer: Customer
    var payment: Payment

    /// Indicates that this `LIST` transaction is initiated with 'preset' option. When selected by customer network and provided account are saved in the system until this `LIST` session will be closed by additional `CHARGE` request. Callback must specify 'summaryUrl' for this type of `LIST` transaction.
    @available(*, deprecated, message: "Use `operationType` instead.")
    var presetFirst: Bool?

    var style: Style?

    /// Type of operation this `LIST` session is initialized for.
    ///
    /// **Default** type is `CHARGE` unless `operationType` is explicitly set or one of the legacy options is supplied during `LIST` initialization: `updateOnly`, `presetFirst`, or `preselection.direction`
    var operationType: String?
}

extension Transaction {
    /// Load template transaction from JSON.
    /// - Parameter amount: you could specify a custom amount (used as "magic number" for testing).
    static func loadFromTemplate(amount: Double = 1.99) -> Transaction {
        let bundle = Bundle(for: PaymentSessionService.self)
        let url = bundle.url(forResource: "Transaction", withExtension: "json")!
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Unable to find Transaction.json")
        }

        var transaction = try! JSONDecoder().decode(Transaction.self, from: data)
        transaction.payment.amount = amount

        return transaction
    }
}
