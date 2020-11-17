import Foundation

extension Input.Field {
    final class HolderName: BasicText {}
}

extension Input.Field.HolderName: TextInputField {}

extension Input.Field.HolderName: Validatable {
    func localize(error: Input.Field.Validation.ValidationError) -> String {
        switch error {
        case .invalidValue, .incorrectLength: return translator.translation(forKey: "error.INVALID_HOLDER_NAME")
        case .missingValue: return translator.translation(forKey: "error.MISSING_HOLDER_NAME")
        }
    }
}

#if canImport(UIKit)
import UIKit

extension Input.Field.HolderName: CellRepresentable, DefinesKeyboardStyle {
    var contentType: UITextContentType? { return .name }
    var autocapitalizationType: UITextAutocapitalizationType { .words }
}
#endif
