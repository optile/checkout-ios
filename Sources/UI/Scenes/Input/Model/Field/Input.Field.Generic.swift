import Foundation

extension Input.Field {
    /// Generic input field model that is used for all `localizableInputElements` that doesn't have explict type (e.g. `AccountNumber`)
    final class Generic: InputElementModel {
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

extension Input.Field.Generic: TextInputField {
    var maxInputLength: Int? { nil }
}

#if canImport(UIKit)
import UIKit

extension Input.Field.Generic: CellRepresentable, DefinesKeyboardStyle {}
#endif
