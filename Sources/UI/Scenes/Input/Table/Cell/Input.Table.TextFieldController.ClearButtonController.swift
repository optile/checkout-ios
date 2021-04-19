// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit
import MaterialComponents.MaterialTextFields

extension Input.Table.TextFieldController {
    /// Class responsible for displaying a custom clear button instead of default's one
    class ClearButtonController {
        unowned let textField: MDCTextField
        private let button = UIButton()

        init(textField: MDCTextField) {
            self.textField = textField
            button.setImage(AssetProvider.iconClear, for: .normal)
            button.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        }
    }
}

extension Input.Table.TextFieldController.ClearButtonController {
    /// Assign custom clear button if needed
    /// - Note: method could be called multiple times (e.g. when cell is being reconfigured)
    func configure() {
        guard textField.clearButtonMode == .whileEditing else { return }

        // Assign custom clear button as a trailing view
        textField.rightView = button
        button.sizeToFit()

        // Hide default clear button
        textField.clearButton.isHidden = true

        updateCustomClearButtonVisibility()
    }

    /// Update clear button state
    func textFieldDidChange() {
        if textField.clearButtonMode == .never { return }
        updateCustomClearButtonVisibility()
    }

    private func updateCustomClearButtonVisibility() {
        let text = textField.text ?? String()
        textField.rightView?.isHidden = text.isEmpty
    }

    @objc private func clearText() {
        textField.text = nil
        textField.rightView?.isHidden = true
    }
}
