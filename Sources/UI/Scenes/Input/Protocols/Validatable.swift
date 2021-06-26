// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

protocol Validatable: AnyObject {
    var validationRule: Input.Field.Validation.Rule? { get }
    var validationErrorText: String? { get set }

    func validateAndSaveResult(option: Input.Field.Validation.Option)
    func validate(using option: Input.Field.Validation.Option) -> Input.Field.Validation.Result

    func localize(error: Input.Field.Validation.ValidationError) -> String

    /// Optional method to add additional value checks (such as IBAN or Luhn validation).
    /// Default: true
    var isPassedCustomValidation: Bool { get }
}

extension Validatable {
    /// Validate and write result to `validationResult`
    func validateAndSaveResult(option: Input.Field.Validation.Option) {
        switch validate(using: option) {
        case .success:
            validationErrorText = nil
        case .failure(let validationError):
            validationErrorText = localize(error: validationError)
        }
    }

    var isPassedCustomValidation: Bool { return true }
}

// MARK: - TextInputField

extension TextInputField where Self: Validatable {
    var maxInputLength: Int? {
        return validationRule?.maxLength
    }
}

extension Validatable where Self: TextInputField {
    func validate(using option: Input.Field.Validation.Option) -> Input.Field.Validation.Result {
        if case .preCheck = option {
            guard isValueExists else {
                // If value doesn't exists don't proceed
                return .success
            }
        }

        guard isValueValid else {
            if !isValueExists {
                return .failure(.missingValue)
            }

            return .failure(.invalidValue)
        }

        guard isCorrectLength else {
            return .failure(.incorrectLength)
        }

        return .success
    }

    fileprivate var isValueExists: Bool {
        return !value.isEmpty
    }

    fileprivate var isCorrectLength: Bool {
        guard let maxLength = validationRule?.maxLength else {
            return true
        }

        guard value.count <= maxLength else {
            return false
        }

        return true
    }

    fileprivate var isValueValid: Bool {
        if let regex = validationRule?.regex {
            let isMatched = (value.range(of: regex, options: .regularExpression) != nil)

            guard isMatched else {
                return false
            }
        }

        guard isPassedCustomValidation else {
            return false
        }

        return true
    }
}

// MARK: - SelectInputField

extension Validatable where Self: SelectInputField {
    var validationRule: Input.Field.Validation.Rule? { return nil }

    func validate(using option: Input.Field.Validation.Option) -> Input.Field.Validation.Result {
        switch option {
        case .preCheck:
            guard isValueExists else {
                // If value doesn't exists don't proceed
                return .success
            }
        case .fullCheck:
            guard isValueExists else {
                return .failure(.missingValue)
            }
        }

        // Valid value, we check validity only if value is not empty. If it is empty you want to check it with `.valueExists`
        if let options = inputElement.options {
            let validLabels: [String] = options.compactMap { selectOption in
                // Example key: `account.expiryMonth.05`
                let translationKey = "account." + inputElement.name + "." + selectOption.value
                guard let translatedLabel = translator.translation(forKey: translationKey) else { return nil }
                return translatedLabel
            }

            guard validLabels.contains(value) else {
                return .failure(.invalidValue)
            }
        }

        return .success
    }
}
