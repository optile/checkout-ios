import Foundation

extension Input.Field {
    final class AccountNumber {
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

extension Input.Field.AccountNumber: TextInputField {}

extension Input.Field.AccountNumber: Validatable {
    func localize(error: Input.Field.Validation.ValidationError) -> String {
        switch error {
        case .invalidValue, .incorrectLength: return translator.translation(forKey: "error.INVALID_ACCOUNT_NUMBER")
        case .missingValue: return translator.translation(forKey: "error.MISSING_ACCOUNT_NUMBER")
        }
    }
}

#if canImport(UIKit)
import UIKit

extension Input.Field.AccountNumber: CellRepresentable, DefinesKeyboardStyle {
    var contentType: UITextContentType? { return .creditCardNumber }
}
#endif
