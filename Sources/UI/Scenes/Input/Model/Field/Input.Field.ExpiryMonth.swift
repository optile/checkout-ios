import Foundation

extension Input.Field {
    final class ExpiryMonth {
        let inputElement: InputElement
        let translator: TranslationProvider
        var validationErrorText: String?
        
        var value: String = ""
        
        weak var expiryYearField: ExpiryYear?
        
        init(from inputElement: InputElement, translator: TranslationProvider) {
            self.inputElement = inputElement
            self.translator = translator
        }
    }
}

extension Input.Field.ExpiryMonth: Validatable {
    func localize(error: Input.Field.Validation.ValidationError) -> String {
        switch error {
        case .invalidValue, .incorrectLength: return translator.translation(forKey: "error.INVALID_EXPIRY_MONTH")
        case .missingValue: return translator.translation(forKey: "error.MISSING_EXPIRY_MONTH")
        }
    }
    
    var isPassedCustomValidation: Bool {
        guard let expiryYear = expiryYearField?.value else {
            // Don't check if year is not filled, that have to be done when is filled option is used.
            return true
        }
        
        let validationResult = Input.Field.Validation.ExpiryDate.isInFuture(expiryMonth: value, expiryYear: expiryYear) ?? false
        return validationResult
    }
}

extension Input.Field.ExpiryMonth: SelectInputField {}

#if canImport(UIKit)
import UIKit

extension Input.Field.ExpiryMonth: CellRepresentable, DefinesKeyboardStyle {
    var keyboardType: UIKeyboardType {
        return .numberPad
    }
}
#endif
