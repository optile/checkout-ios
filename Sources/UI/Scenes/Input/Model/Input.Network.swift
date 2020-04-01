import Foundation

extension Input {
    class Network {
        let translation: TranslationProvider

        let label: String
        let logoData: Data?
        let inputFields: [CellRepresentable]
        
        /// Checkboxes that must be arranged in another section (used for reccurence and registration)
        let separatedCheckboxes: [Input.Field.Checkbox]
        
        let submitButton: Input.Field.Button
        
        let switchRule: SmartSwitch.Rule?
        let networkCode: String

        init(networkCode: String, translator: TranslationProvider, label: String, logoData: Data?, inputFields: [CellRepresentable], separatedCheckboxes: [Field.Checkbox], submitButton: Field.Button, switchRule: SmartSwitch.Rule?) {
            self.networkCode = networkCode
            self.translation = translator
            
            self.label = label
            self.logoData = logoData
            self.inputFields = inputFields
            self.separatedCheckboxes = separatedCheckboxes
            self.submitButton = submitButton
            self.switchRule = switchRule
        }
    }
}

extension Input.Network: Equatable {
    static func == (lhs: Input.Network, rhs: Input.Network) -> Bool {
        return (lhs.networkCode == rhs.networkCode) && (lhs.label == rhs.label)
    }
}

#if canImport(UIKit)
import UIKit

extension Input.Network {
    var logo: UIImage? {
        guard let data = self.logoData else { return nil }
        return UIImage(data: data)
    }
}
#endif
