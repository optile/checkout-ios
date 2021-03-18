// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import XCTest
@testable import PayoneerCheckout

class ValidationTests: XCTestCase {
    private let translationProvider = KeysOnlyTranslationProvider()
    private let validationProvider = try! Input.Field.Validation.Provider()

    /// Run multiple tests for input fields.
    /// Tests configurations is stored at `MockFactory.Validation` JSON.
    func testInputFieldValidations() {
        for network in MockFactory.Validation.validationTestCases {
            var networkName: String = ""

            if let code = network.code {
                networkName = code
            }

            if let method = network.method {
                networkName += " (" + method + ")"
            }

            XCTContext.runActivity(named: "Test network " + networkName) { _ in
                // Make a fake network from ruleset
                let testableInputElements = makeTestableInputElements(for: network)

                for testableInputElement in testableInputElements {
                    XCTContext.runActivity(named: "Test input element " + testableInputElement.name) { (activity) in
                        testableInputElement.test(within: activity)
                    }
                }
            }
        }
    }

    /// Make applicable network with one input field for each input element's test case.
    private func makeTestableInputElements(for validatableNetwork: MockFactory.Validation.Network) -> [TestableInputElement] {
        var networks = [TestableInputElement]()

        for inputElementWithRules in validatableNetwork.inputElements {
            // Network variables
            let networkCode = validatableNetwork.code ?? ""
            let method = validatableNetwork.method ?? ""

            let inputElement = InputElement(name: inputElementWithRules.name, type: "")
            let applicableNetwork = ApplicableNetwork(code: networkCode, label: "", method: method, grouping: "", registration: "", recurrence: "", redirect: false, inputElements: [inputElement], links: ["operation": URL(string: "https://example.com")!])
            let paymentNetwork = PaymentNetwork(from: applicableNetwork, submitButtonLocalizationKey: "", localizeUsing: translationProvider)
            let testableInputElement = TestableInputElement(name: inputElementWithRules.name, network: paymentNetwork, testCases: inputElementWithRules.tests)
            networks.append(testableInputElement)
        }

        return networks
    }

    private class TestableInputElement {
        let network: PaymentNetwork
        let name: String
        let testCases: [MockFactory.Validation.InputElementTestCase]

        func test(within activity: XCTActivity) {
            let transformer = Input.ModelTransformer()
            let inputNetwork = try! transformer.transform(paymentNetwork: network)

            guard let inputElement = inputNetwork.uiModel.inputFields.first else {
                fatalError("Input element is not present applicable network, programmatic error")
            }

            let attachment = XCTAttachment(subject: inputElement)
            attachment.name = "inputField_\(inputElement.name)"
            activity.add(attachment)

            guard let validatableInputElement = inputElement as? InputField & Validatable else {
                XCTFail("InputField doesn't conform to Validatable protocol")
                return
            }

            for testCase in testCases {
                let activityName = testCase.value ?? "<nil>"

                XCTContext.runActivity(named: "Test using value \(activityName)") {
                    test(inputElement: validatableInputElement, testCase: testCase, within: $0)
                }
            }
        }

        private func test(inputElement: InputField & Validatable, testCase: MockFactory.Validation.InputElementTestCase, within activity: XCTActivity) {
            inputElement.validationErrorText = nil
            inputElement.value = testCase.value ?? ""
            inputElement.validateAndSaveResult(option: .fullCheck)

            let attachment = XCTAttachment(subject: testCase)
            attachment.name = "testCase"
            activity.add(attachment)

            if let expectedError = testCase.error {
                let expectedLocalizationErrorKey = "error." + expectedError

                XCTAssertEqual(inputElement.validationErrorText, expectedLocalizationErrorKey)
            } else {
                XCTAssertEqual(inputElement.validationErrorText, nil)
            }
        }

        init(name: String, network: PaymentNetwork, testCases: [MockFactory.Validation.InputElementTestCase]) {
            self.name = name
            self.network = network
            self.testCases = testCases
        }
    }
}

/// Translation provider that doesn't translate (we don't need in that test case), it just returns localization keys as translation
private class KeysOnlyTranslationProvider: TranslationProvider {
    let translations = [[String: String]]()

    func translation(forKey key: String) -> String {
        return key
    }

    func translation(forKey key: String) -> String? {
        fatalError("Method is prohibited and shouldn't be called")
    }
}
