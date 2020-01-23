import Foundation

extension Input.Field {
    final class ExpiryYear {
        let inputElement: InputElement
        let translator: TranslationProvider
        var validationErrorText: String?
        
        var value: String?
        
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
