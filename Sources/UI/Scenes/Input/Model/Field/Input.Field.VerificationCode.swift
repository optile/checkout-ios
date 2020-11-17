import Foundation

// MARK: Protocol

protocol VerificationCodeTranslationKeySuffixer: class {
    /// Generic / specific key for placeholder translation without dot (e.g. `generic`)
    var suffixKey: String { get }
}

// MARK: - VerificationCodeField

extension Input.Field {
    final class VerificationCode: InputElementModel {
        /// Network that contains that field
        let networkCode: String
        
        let inputElement: InputElement
        let translator: TranslationProvider
        let validationRule: Validation.Rule?
        var validationErrorText: String?

        var isEnabled: Bool = true
        var value: String = ""

        weak var keySuffixer: VerificationCodeTranslationKeySuffixer?

        init(from inputElement: InputElement, networkCode: String, translator: TranslationProvider, validationRule: Validation.Rule?) {
            self.inputElement = inputElement
            self.networkCode = networkCode
            self.translator = translator
            self.validationRule = validationRule
        }
    }
}

extension Input.Field.VerificationCode: TextInputField {
    var placeholder: String {
        let key: String

        if let suffix = keySuffixer?.suffixKey {
            key = translationPrefix + suffix + ".placeholder"
        } else {
            let error = InternalError(description: "keySuffixer is not set, it's not an intended behaviour, programmatic error")
            error.log()

            key = translationPrefix + "placeholder"
        }

        return translator.translation(forKey: key)
    }

    var allowedCharacters: CharacterSet? { return .decimalDigits }
}

extension Input.Field.VerificationCode: Validatable {
    func localize(error: Input.Field.Validation.ValidationError) -> String {
        switch error {
        case .invalidValue, .incorrectLength: return translator.translation(forKey: "error.INVALID_VERIFICATION_CODE")
        case .missingValue: return translator.translation(forKey: "error.MISSING_VERIFICATION_CODE")
        }
    }
}

#if canImport(UIKit)
import UIKit

extension Input.Field.VerificationCode: CellRepresentable, DefinesKeyboardStyle {
    var keyboardType: UIKeyboardType { .numberPad }
    
    var cellType: (UICollectionViewCell & DequeueableCell).Type { Input.Table.CVVTextFieldViewCell.self }
}
#endif
