import Foundation

extension Input.Field {
    final class BankCode: BasicText {}
}

extension Input.Field.BankCode: TextInputField {}

extension Input.Field.BankCode: Validatable {
    func localize(error: Input.Field.Validation.ValidationError) -> String {
        switch error {
        case .invalidValue, .incorrectLength: return translator.translation(forKey: "error.INVALID_BANK_CODE")
        case .missingValue: return translator.translation(forKey: "error.MISSING_BANK_CODE")
        }
    }
}

#if canImport(UIKit)
import UIKit

extension Input.Field.BankCode: CellRepresentable, DefinesKeyboardStyle {}
#endif
