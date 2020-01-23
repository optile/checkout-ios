import Foundation

extension Input.Field {
    class Transformer {
        /// Transformed verification code fields.
        /// - Note: we need it to set a placholder suffix delegate after transformation
        fileprivate(set) var verificationCodeFields = [Input.Field.VerificationCode]()
        
        init() {}
    }
}

extension Input.Field.Transformer {
    /// Transform `PaymentNetwork` to `Input.Network`
    func transform(paymentNetwork: PaymentNetwork) -> Input.Network {
        // Logo
        let logoData: Data?
        
        // Was loading started? Was loading completed? Was it completed successfully?
        if case let .some(.loaded(.success(imageData))) = paymentNetwork.logo {
            logoData = imageData
        } else {
            logoData = nil
        }
        
        // Get validation rules for a network
        let validationRules: [Input.Field.Validation.Rule]
        
        do {
            let networks = try Input.Field.Validation.Provider().get()
            if let network = networks.first(withCode: paymentNetwork.applicableNetwork.code) {
                validationRules = network.items
            } else {
                validationRules = [Input.Field.Validation.Rule]()
            }
        } catch {
            let getRulesError = InternalError(description: "Failed to get validation rules: %@", objects: error)
            getRulesError.log()
            
            validationRules = [Input.Field.Validation.Rule]()
        }
        
        // Transform input fields
        let inputElements = paymentNetwork.applicableNetwork.localizedInputElements ?? [InputElement]()
        let inputFields = inputElements.map { inputElement -> InputField & CellRepresentable in
            let validationRule = validationRules.first(withType: inputElement.name)
            return transform(inputElement: inputElement, translateUsing: paymentNetwork.translation, validationRule: validationRule)
        }

        // Get SmartSwitch rules for a network
        let switchRule: Input.SmartSwitch.Rule?
        do {
            let switchProvider = Input.SmartSwitch.Provider()
            switchRule = try switchProvider.getRules().first(withCode: paymentNetwork.applicableNetwork.code)
        } catch {
            let internalError = InternalError(description: "Unable to decode smart switch rules: %@", objects: error)
            internalError.log()
            
            switchRule = nil
        }
        
        return .init(paymentNetwork: paymentNetwork, label: paymentNetwork.label, logoData: logoData, inputFields: inputFields, switchRule: switchRule)
    }
    
    /// Transform `InputElement` to `InputField`
    private func transform(inputElement: InputElement, translateUsing translator: TranslationProvider, validationRule: Input.Field.Validation.Rule?) -> InputField & CellRepresentable {
        switch (inputElement.name, inputElement.inputElementType) {
        case ("number", .some(.numeric)):
            return Input.Field.AccountNumber(from: inputElement, translator: translator, validationRule: validationRule)
        case ("holderName", .some(.string)):
            return Input.Field.HolderName(from: inputElement, translator: translator, validationRule: validationRule)
        case ("verificationCode", .some(.integer)):
            let field = Input.Field.VerificationCode(from: inputElement, translator: translator, validationRule: validationRule)
            verificationCodeFields.append(field)
            return field
        case ("expiryMonth", .some(.select)):
            return Input.Field.ExpiryMonth(from: inputElement, translator: translator)
        case ("expiryYear", .some(.select)):
            return Input.Field.ExpiryYear(from: inputElement, translator: translator)
        default:
            return Input.Field.Generic(from: inputElement, translator: translator, validationRule: validationRule)
        }
    }
}
