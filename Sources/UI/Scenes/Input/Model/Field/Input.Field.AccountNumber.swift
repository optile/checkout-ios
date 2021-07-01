// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

extension Input.Field {
    final class AccountNumber: BasicText {
        let paymentMethod: String?
        let patternFormatter: InputPatternFormatter?

        /// - Parameters:
        ///   - networkMethod: Indicates payment method this network belongs (from `ApplicableNetwork`)
        init(from inputElement: InputElement, translator: TranslationProvider, validationRule: Validation.Rule?, paymentMethod: String?) {
            self.paymentMethod = paymentMethod

            // Pattern formatter
            let maxLength = validationRule?.maxLength ?? 34
            patternFormatter = .init(maxStringLength: maxLength, separator: " ", every: 4)

            super.init(from: inputElement, translator: translator, validationRule: validationRule)
        }
    }
}

extension Input.Field.AccountNumber: TextInputField {
    var allowedCharacters: CharacterSet? { return .decimalDigits }
}

extension Input.Field.AccountNumber: Validatable {
    private var luhnValidatableMethods: [String] { ["DEBIT_CARD", "CREDIT_CARD"] }

    func localize(error: Input.Field.Validation.ValidationError) -> String {
        switch error {
        case .invalidValue, .incorrectLength: return translator.translation(forKey: "error.INVALID_ACCOUNT_NUMBER")
        case .missingValue: return translator.translation(forKey: "error.MISSING_ACCOUNT_NUMBER")
        }
    }

    var isPassedCustomValidation: Bool {
        guard let paymentMethod = self.paymentMethod else { return true }

        // Validate only some networks
        if luhnValidatableMethods.contains(paymentMethod) {
            return Input.Field.Validation.Luhn.isValid(accountNumber: value)
        }

        return true
    }
}

#if canImport(UIKit)
import UIKit

extension Input.Field.AccountNumber: CellRepresentable, DefinesKeyboardStyle {
    var contentType: UITextContentType? { return .creditCardNumber }
}
#endif
