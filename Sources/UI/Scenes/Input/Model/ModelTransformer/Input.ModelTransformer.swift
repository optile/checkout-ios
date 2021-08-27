// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation
import UIKit

// MARK: Constants

extension Input.ModelTransformer {
    struct Constant {
        static var ignoredFields: [IgnoredFields] { [
            .init(networkCode: "SEPADD", inputElementName: "bic")
        ] }

        static var registrationCheckboxLocalizationKey: String { "autoRegistrationLabel" }
        static var recurrenceCheckboxLocalizationKey: String { "allowRecurrenceLabel" }
    }
}

// MARK: - Transformer

extension Input {
    /// Transformer from `List` models to `Input` UI models.
    class ModelTransformer {
        fileprivate let inputFieldFactory = InputFieldFactory()

        init() {}
    }
}

extension Input.ModelTransformer {
    func transform(registeredAccount: RegisteredAccount) throws -> Input.Network {
        let logo = registeredAccount.logo?.value

        // Input fields
        let inputElements = registeredAccount.apiModel.inputElements ?? [InputElement]()
        let modelToTransform = InputFieldFactory.TransformableModel(inputElements: inputElements, networkCode: registeredAccount.apiModel.code, paymentMethod: nil, translator: registeredAccount.translation)
        let inputFields = inputFieldFactory.createInputFields(for: modelToTransform)

        // Operation URL
        guard let operationURL = registeredAccount.apiModel.links["operation"] else {
            throw InternalError(description: "Incorrect registered account model, operation URL is not present. Links: %@", objects: registeredAccount.apiModel.links)
        }

        // Detect if we're in UPDATE flow
        let isDeletable = registeredAccount.apiModel.operationType == "UPDATE"

        // Check if we need to show a submit button
        let submitButton: Input.Field.Button?
        if registeredAccount.apiModel.operationType == "UPDATE", inputFields.isEmpty {
            submitButton = nil
        } else {
            submitButton = Input.Field.Button(label: registeredAccount.submitButtonLabel)
        }

        let uiModel = Input.Network.UIModel(
            networkLabel: registeredAccount.networkLabel,
            maskedAccountLabel: registeredAccount.maskedAccountLabel,
            logo: logo,
            inputFieldsByCategory: [.account: inputFields],
            submitButton: submitButton
        )

        return .init(
            apiModel: .account(registeredAccount.apiModel),
            operationURL: operationURL,
            paymentMethod: registeredAccount.apiModel.method,
            networkCode: registeredAccount.apiModel.code,
            translator: registeredAccount.translation,
            switchRule: nil,
            uiModel: uiModel,
            isDeletable: isDeletable
        )
    }

    func transform(paymentNetwork: PaymentNetwork) throws -> Input.Network {
        let logo = paymentNetwork.logo?.value

        // Input fields
        let inputElements = paymentNetwork.applicableNetwork.inputElements ?? [InputElement]()

        let modelToTransform = InputFieldFactory.TransformableModel(
            inputElements: inputElements,
            networkCode: paymentNetwork.applicableNetwork.code,
            paymentMethod: paymentNetwork.applicableNetwork.method,
            translator: paymentNetwork.translation
        )

        // Switch rule
        let smartSwitchRule = switchRule(forNetworkCode: paymentNetwork.applicableNetwork.code)

        // Checkboxes
        let checkboxFactory = RegistrationOptionsBuilder(translator: paymentNetwork.translation, operationType: paymentNetwork.applicableNetwork.operationType)
        let registrationCheckbox = RegistrationOptionsBuilder.RegistrationOption(type: .registration, requirement: paymentNetwork.applicableNetwork.registrationRequirement)
        let recurrenceCheckbox = RegistrationOptionsBuilder.RegistrationOption(type: .recurrence, requirement: paymentNetwork.applicableNetwork.recurrenceRequirement)

        // Input fields
        let registrationInputFields = [
            checkboxFactory.createInternalModel(from: registrationCheckbox),
            checkboxFactory.createInternalModel(from: recurrenceCheckbox)
            ].compactMap { $0 }

        let paymentInputFields = inputFieldFactory.createInputFields(for: modelToTransform)

        let inputFields: [Input.Network.UIModel.InputFieldCategory: [InputField]] = [
            .account: paymentInputFields,
            .registration: registrationInputFields
        ]

        let submitButton = Input.Field.Button(label: paymentNetwork.submitButtonLabel)

        let uiModel = Input.Network.UIModel(networkLabel: paymentNetwork.label,
                                            maskedAccountLabel: nil,
                                            logo: logo, inputFieldsByCategory: inputFields,
                                            submitButton: submitButton)

        // Operation URL
        guard let operationURL = paymentNetwork.applicableNetwork.links?["operation"] else {
            throw InternalError(description: "Incorrect applicable network model, operation URL is not present. Links: %@", objects: paymentNetwork.applicableNetwork.links)
        }

        return .init(apiModel: .network(paymentNetwork.applicableNetwork),
                     operationURL: operationURL,
                     paymentMethod: paymentNetwork.applicableNetwork.method,
                     networkCode: paymentNetwork.applicableNetwork.code,
                     translator: paymentNetwork.translation,
                     switchRule: smartSwitchRule,
                     uiModel: uiModel,
                     isDeletable: false)
    }

    // MARK: Smart Switch

    /// Get SmartSwitch rule for a network
    private func switchRule(forNetworkCode networkCode: String) -> Input.SmartSwitch.Rule? {
        do {
            let switchProvider = Input.SmartSwitch.Provider()
            return try switchProvider.getRules().first(withCode: networkCode)
        } catch {
            let internalError = InternalError(description: "Unable to decode smart switch rules: %@", objects: error)
            internalError.log()

            return nil
        }
    }
}

extension Input.ModelTransformer {
    struct IgnoredFields {
        let networkCode: String
        let inputElementName: String
    }
}
