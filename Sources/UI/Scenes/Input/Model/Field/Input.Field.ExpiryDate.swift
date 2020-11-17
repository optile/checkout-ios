import Foundation

extension Input.Field {
    final class ExpiryDate {
        let translator: TranslationProvider
        var validationErrorText: String?

        let patternFormatter: InputPatternFormatter? = {
            let formatter = InputPatternFormatter(textPattern: "## / ##")
            formatter.shouldAddTrailingPattern = true
            formatter.inputModifiers = [ExpirationDateInputModifier()]
            return formatter
        }()

        var isEnabled: Bool = true
        var value: String = ""

        init(translator: TranslationProvider) {
            self.translator = translator
        }
    }
}

extension Input.Field.ExpiryDate: Validatable {
    var validationRule: Input.Field.Validation.Rule? { nil }

    func localize(error: Input.Field.Validation.ValidationError) -> String {
        switch error {
        case .invalidValue, .incorrectLength: return translator.translation(forKey: "error.INVALID_EXPIRY_DATE")
        case .missingValue: return translator.translation(forKey: "error.MISSING_EXPIRY_DATE")
        }
    }

    var isPassedCustomValidation: Bool {
        guard value.count == 4 else {
            return false
        }

        // Get current year without suffix (we will add that suffix later)
        // E.g. 2050 = 20
        let calendar = Calendar.current
        let currentYear = String(calendar.component(.year, from: Date()))
        let prefixCharacters = currentYear.count - 2
        let currentYearWithoutSuffix = currentYear.prefix(prefixCharacters)

        guard let month = Int(String(value.prefix(2))) else { return false }
        guard let year = Int(String(currentYearWithoutSuffix + value.suffix(2))) else { return false }
        guard month >= 1, month <= 12 else { return false }

        let validationResult = Input.Field.Validation.ExpiryDate.isInFuture(expiryMonth: month, expiryYear: year) ?? false
        return validationResult
    }
}

extension Input.Field.ExpiryDate: TextInputField {
    var maxInputLength: Int? { 4 }
    var name: String { "expiryDate" }
    var allowedCharacters: CharacterSet? { return .decimalDigits }

    // We need to switch placeholder and label for the field

    var label: String {
        translator.translation(forKey: translationPrefix + "placeholder")
    }

    var placeholder: String {
        translator.translation(forKey: translationPrefix + "label")
    }

    private var translationPrefix: String { "account." + name + "." }
}

#if canImport(UIKit)
import UIKit

extension Input.Field.ExpiryDate: CellRepresentable, DefinesKeyboardStyle {
    var keyboardType: UIKeyboardType {
        return .numberPad
    }
}
#endif
