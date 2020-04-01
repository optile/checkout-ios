import Foundation

extension Input.Field {
    final class IBAN: InputElementModel {
        let inputElement: InputElement
        let translator: TranslationProvider
        let validationRule: Validation.Rule?
        var validationErrorText: String?
        
        var value: String = ""
        
        init(from inputElement: InputElement, translator: TranslationProvider, validationRule: Validation.Rule?) {
            self.inputElement = inputElement
            self.translator = translator
            self.validationRule = validationRule
        }
    }
}

extension Input.Field.IBAN: TextInputField {}

extension Input.Field.IBAN: Validatable {
    func localize(error: Input.Field.Validation.ValidationError) -> String {
        switch error {
        case .invalidValue, .incorrectLength: return translator.translation(forKey: "error.INVALID_IBAN")
        case .missingValue: return translator.translation(forKey: "error.MISSING_IBAN")
        }
    }
    
    var isPassedCustomValidation: Bool {
        return Input.Field.Validation.IBAN.isValid(iban: value)
    }
}

#if canImport(UIKit)
import UIKit

extension Input.Field.IBAN: CellRepresentable, DefinesKeyboardStyle {
    var keyboardType: UIKeyboardType { .asciiCapable }
}
#endif
