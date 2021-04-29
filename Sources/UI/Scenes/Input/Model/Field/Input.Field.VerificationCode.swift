// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

extension Input.Field {
    final class VerificationCode: InputElementModel {
        /// Network that contains that field
        let networkCode: String

        let inputElement: InputElement
        let translator: TranslationProvider
        let validationRule: Validation.Rule?
        var validationErrorText: String?

        var isEnabled: Bool = true
        var value: String = ""

        init(from inputElement: InputElement, networkCode: String, translator: TranslationProvider, validationRule: Validation.Rule?) {
            self.inputElement = inputElement
            self.networkCode = networkCode
            self.translator = translator
            self.validationRule = validationRule
        }
    }
}

extension Input.Field.VerificationCode: TextInputField {
    var placeholder: String {
        translator.translation(forKey: translationPrefix + "specific.placeholder")
    }

    var label: String {
        translator.translation(forKey: translationPrefix + "generic.placeholder")
    }

    var allowedCharacters: CharacterSet? { return .decimalDigits }
}

extension Input.Field.VerificationCode: Validatable {
    func localize(error: Input.Field.Validation.ValidationError) -> String {
        switch error {
        case .invalidValue, .incorrectLength: return translator.translation(forKey: "error.INVALID_VERIFICATION_CODE")
        case .missingValue: return translator.translation(forKey: "error.MISSING_VERIFICATION_CODE")
        }
    }
}

#if canImport(UIKit)
import UIKit

extension Input.Field.VerificationCode: CellRepresentable, DefinesKeyboardStyle {
    var keyboardType: UIKeyboardType { .numberPad }

    var cellType: (UICollectionViewCell & DequeueableCell).Type { Input.Table.CVVTextFieldViewCell.self }
}
#endif
