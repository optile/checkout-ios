import UIKit
import Foundation

extension Input {
    final class TextHeader {
        let logoData: Data?
        let label: String
        var detailedLabel: String?

        private init(logoData: Data?, label: String) {
            self.logoData = logoData
            self.label = label
        }
        
        /// Initializes header with transformed label and detailed label from `maskedAccount` data.
        convenience init(from registeredAccount: RegisteredAccount) {
            let label: String
            
            // Use custom transformation
            if let number = registeredAccount.apiModel.maskedAccount.number {
                // Expected input number format: `41 *** 1111`
                let maskedNumber = "•••• " + number.suffix(4)
                label = [registeredAccount.networkLabel, maskedNumber].joined(separator: " ")
                // Output: VISA •••• 1234
            } else if let iban = registeredAccount.apiModel.maskedAccount.iban {
                label = iban.prefix(2) + " •••• " + iban.suffix(2)
                // Output: DE •••• 24
            } else {
                // Fallback to server's display label
                label = registeredAccount.apiModel.maskedAccount.displayLabel ?? ""
            }
            
            self.init(logoData: registeredAccount.logo?.value, label: label)
            
            if let expiryMonth = registeredAccount.apiModel.maskedAccount.expiryMonth, let expiryYear = registeredAccount.apiModel.maskedAccount.expiryYear {
                detailedLabel = String(format: "%02d", expiryMonth) + " / " + String(expiryYear).suffix(2)
            }
        }
    }
}

extension Input.TextHeader: ViewRepresentable {
    func configure(view: UIView) throws {
        switch view {
        case let view as Input.Table.LogoTextView: view.configure(with: self)
        case let view as Input.Table.DetailedTextLogoView: view.configure(with: self)
        default: throw errorForIncorrectView(view)
        }
    }
    
    var configurableViewType: UIView.Type {
        return detailedLabel == nil ? Input.Table.LogoTextView.self : Input.Table.DetailedTextLogoView.self
    }
}
