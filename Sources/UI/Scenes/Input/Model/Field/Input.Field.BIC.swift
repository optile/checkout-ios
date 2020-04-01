import Foundation

extension Input.Field {
    final class BIC: InputElementModel {
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

extension Input.Field.BIC: TextInputField {}

extension Input.Field.BIC: Validatable {
    func localize(error: Input.Field.Validation.ValidationError) -> String {
        switch error {
        case .invalidValue, .incorrectLength: return translator.translation(forKey: "error.INVALID_BIC")
        case .missingValue: return translator.translation(forKey: "error.MISSING_BIC")
        }
    }
}

#if canImport(UIKit)
import UIKit

extension Input.Field.BIC: CellRepresentable, DefinesKeyboardStyle {}
#endif
