import Foundation

extension Input.Field {
    final class AccountNumber: InputElementModel {
        let inputElement: InputElement
        let translator: TranslationProvider
        let validationRule: Validation.Rule?
        let networkMethod: String?
        var validationErrorText: String?
        
        var value: String = ""

        /// - Parameters:
        ///   - networkMethod: Indicates payment method this network belongs (from `ApplicableNetwork`)
        init(from inputElement: InputElement, translator: TranslationProvider, validationRule: Validation.Rule?, networkMethod: String?) {
            self.inputElement = inputElement
            self.translator = translator
            self.validationRule = validationRule
            self.networkMethod = networkMethod
        }
    }
}

extension Input.Field.AccountNumber: TextInputField {}

extension Input.Field.AccountNumber: Validatable {
    private var luhnValidatableMethods: [String] { ["DEBIT_CARD", "CREDIT_CARD"] }
    
    func localize(error: Input.Field.Validation.ValidationError) -> String {
        switch error {
        case .invalidValue, .incorrectLength: return translator.translation(forKey: "error.INVALID_ACCOUNT_NUMBER")
        case .missingValue: return translator.translation(forKey: "error.MISSING_ACCOUNT_NUMBER")
        }
    }
    
    var isPassedCustomValidation: Bool {
        guard let networkMethod = self.networkMethod else { return true }
        
        // Validate only some networks
        if luhnValidatableMethods.contains(networkMethod) {
            return Input.Field.Validation.Luhn.isValid(accountNumber: value)
        }

        return true
    }
}

#if canImport(UIKit)
import UIKit

extension Input.Field.AccountNumber: CellRepresentable, DefinesKeyboardStyle {
    var contentType: UITextContentType? { return .creditCardNumber }
}
#endif
