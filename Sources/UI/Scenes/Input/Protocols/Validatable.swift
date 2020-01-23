import Foundation

protocol Validatable: class {
    var validationRule: Input.Field.Validation.Rule? { get }
    var validationErrorText: String? { get set }
    
    func validateAndSaveResult(options: Input.Field.Validation.Options)
    func validate(using options: Input.Field.Validation.Options) -> Input.Field.Validation.Result
    func localize(error: Input.Field.Validation.ValidationError) -> String
}

extension Validatable {
    /// Validate and write result to `validationResult`
    func validateAndSaveResult(options: Input.Field.Validation.Options) {
        switch validate(using: options) {
        case .success:
            validationErrorText = nil
        case .failure(let validationError):
            validationErrorText = localize(error: validationError)
        }
    }
}

// MARK: - TextInputField

extension Validatable where Self: TextInputField {
    func validate(using options: Input.Field.Validation.Options) -> Input.Field.Validation.Result {
        // Value exists
        if options.contains(.valueExists) {
            guard let value = self.value, !value.isEmpty else {
                return .failure(.missingValue)
            }
        }
        
        guard let value = self.value, let rule = self.validationRule else {
            return .success
        }
        
        // Correct length
        if options.contains(.maxLength) {
            guard let maxLength = rule.maxLength else {
                return .success
            }
            
            guard value.count <= maxLength else {
                return .failure(.incorrectLength)
            }
        }
        
        // Valid value, we check validity only if value is not empty. If it is empty you want to check it with `.valueExists`
        if options.contains(.validValue), !value.isEmpty, let rule = self.validationRule {
            let isMatched = (value.range(of: rule.regex, options: .regularExpression) != nil)
            guard isMatched else {
                return .failure(.invalidValue)
            }
        }
        
        return .success
    }
}

// MARK: - SelectInputField

extension Validatable where Self: SelectInputField {
    var validationRule: Input.Field.Validation.Rule? { return nil }
    
    func validate(using options: Input.Field.Validation.Options) -> Input.Field.Validation.Result {
        // Value exists
        if options.contains(.valueExists) {
            guard let value = self.value, !value.isEmpty else {
                return .failure(.missingValue)
            }
        }
        
        // Valid value, we check validity only if value is not empty. If it is empty you want to check it with `.valueExists`
        if options.contains(.validValue), let value = self.value, !value.isEmpty, let options = inputElement.options {
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
