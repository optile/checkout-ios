import Foundation

extension Input {
    /// Generic input field model that is used for all `localizableInputElements` that doesn't have explict type (e.g. `AccountNumber`)
    final class GenericInputField {
        let inputElement: InputElement
        let translator: TranslationProvider
        let validationRule: Validation.Rule?
        var validationErrorText: String?
        
        var value: String?
        
        init(from inputElement: InputElement, translator: TranslationProvider, validationRule: Validation.Rule?) {
            self.inputElement = inputElement
            self.translator = translator
            self.validationRule = validationRule
        }
    }
}

extension Input.GenericInputField: TextInputField {}

#if canImport(UIKit)
import UIKit

extension Input.GenericInputField: CellRepresentable, DefinesKeyboardStyle {}
#endif
