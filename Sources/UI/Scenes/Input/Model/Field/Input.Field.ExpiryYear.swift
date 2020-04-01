import Foundation

extension Input.Field {
    final class ExpiryYear: InputElementModel {
        let inputElement: InputElement
        let translator: TranslationProvider
        var validationErrorText: String?
        
        var value: String = ""
        
        weak var expiryMonthField: ExpiryMonth?
        
        init(from inputElement: InputElement, translator: TranslationProvider) {
            self.inputElement = inputElement
            self.translator = translator
        }
    }
}

extension Input.Field.ExpiryYear: Validatable {
    func localize(error: Input.Field.Validation.ValidationError) -> String {
        switch error {
        case .invalidValue, .incorrectLength: return translator.translation(forKey: "error.INVALID_EXPIRY_YEAR")
        case .missingValue: return translator.translation(forKey: "error.MISSING_EXPIRY_YEAR")
        }
    }
    
    var isPassedCustomValidation: Bool {
        guard let expiryMonth = expiryMonthField?.value else {
            // Don't check if year is not filled, that have to be done when is filled option is used.
            return true
        }
        
        let validationResult = Input.Field.Validation.ExpiryDate.isInFuture(expiryMonth: expiryMonth, expiryYear: value) ?? false
        return validationResult
    }
}

extension Input.Field.ExpiryYear: SelectInputField {}

#if canImport(UIKit)
import UIKit

extension Input.Field.ExpiryYear: CellRepresentable, DefinesKeyboardStyle {
    var keyboardType: UIKeyboardType {
        return .numberPad
    }
}
#endif
