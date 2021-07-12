// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

@objc public class Interaction: NSObject, Decodable {
    /// Interaction code that advices further interaction with this customer or payment.
    /// See list of [Interaction Codes](https://www.optile.io/opg#292619).
    public let code: String

    /// Reason of this interaction, complements interaction code and has more detailed granularity.
    /// See list of [Interaction Codes](https://www.optile.io/opg#292619).
    public let reason: String

    internal init(code: Code, reason: Reason) {
        self.code = code.rawValue
        self.reason = reason.rawValue
    }

    internal init(code: String, reason: String) {
        self.code = code
        self.reason = reason
    }
}

public extension Interaction {
    enum Code: String, Decodable {
        case PROCEED, ABORT, TRY_OTHER_NETWORK, TRY_OTHER_ACCOUNT, RETRY, RELOAD, VERIFY
    }

    enum Reason: String, Decodable {
        // swiftlint:disable:next line_length inclusive_language
        case OK, PENDING, TRUSTED, STRONG_AUTHENTICATION, DECLINED, EXPIRED, EXCEEDS_LIMIT, TEMPORARY_FAILURE, UNKNOWN, NETWORK_FAILURE, BLACKLISTED, BLOCKED, SYSTEM_FAILURE, INVALID_ACCOUNT, FRAUD, ADDITIONAL_NETWORKS, INVALID_REQUEST, SCHEDULED, NO_NETWORKS, DUPLICATE_OPERATION, CHARGEBACK, RISK_DETECTED, CUSTOMER_ABORT, EXPIRED_SESSION, EXPIRED_ACCOUNT, ACCOUNT_NOT_ACTIVATED, TRUSTED_CUSTOMER, UNKNOWN_CUSTOMER, ACTIVATED, UPDATED, TAKE_ACTION
        case COMMUNICATION_FAILURE, CLIENTSIDE_ERROR
    }
}
