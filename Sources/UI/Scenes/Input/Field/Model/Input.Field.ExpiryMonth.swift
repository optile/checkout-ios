import Foundation

extension Input.Field {
    final class ExpiryMonth {
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

extension Input.Field.ExpiryMonth: Validatable {
    func localize(error: Input.Field.Validation.ValidationError) -> String {
        switch error {
        case .invalidValue, .incorrectLength: return translator.translation(forKey: "error.INVALID_EXPIRY_MONTH")
        case .missingValue: return translator.translation(forKey: "error.MISSING_EXPIRY_MONTH")
        }
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
