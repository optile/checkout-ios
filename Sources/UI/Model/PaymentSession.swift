// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

final class PaymentSession {
    enum Operation: String {
        case CHARGE, UPDATE
    }

    let networks: [PaymentNetwork]
    let registeredAccounts: [RegisteredAccount]?

    let operationType: Operation

    init(operationType: Operation, networks: [TranslatedModel<ApplicableNetwork>], accounts: [TranslatedModel<AccountRegistration>]?) {
        self.operationType = operationType
        let buttonLocalizationKey = "button.operation." + operationType.rawValue.uppercased() + ".label"

        self.networks = networks.map {
            .init(from: $0.model, submitButtonLocalizationKey: buttonLocalizationKey, localizeUsing: $0.translator)
        }

        self.registeredAccounts = accounts?.map {
            RegisteredAccount(from: $0.model, submitButtonLocalizationKey: buttonLocalizationKey, localizeUsing: $0.translator)
        }
    }
}
