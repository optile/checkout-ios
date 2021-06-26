// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

extension Input.ViewController {
    class DeletionAlertController: UIAlertController {
        private let translator: TranslationProvider

        /// Initialize `UIAlertController` with added message, title and cancel button.
        /// - Note: don't forget to call `addDeleteAction(handler:)` to add a delete button
        /// - Parameters:
        ///   - translator: translator that will be used to translate message, title and buttons
        ///   - accountLabel: account label (e.g. `VISA **** 2021`) that will be used in a message
        init(translator: TranslationProvider, accountLabel: String) {
            self.translator = translator
            
            let title: String = translator.translation(forKey: "accounts.delete.title")

            // Message comes with replacable variable
            var message: String = translator.translation(forKey: "accounts.delete.text")
            message = message.replacingOccurrences(of: "${account.displayLabel}", with: accountLabel)
            
            super.init(title: title, message: message, preferredStyle: .alert)

            let cancelText: String? = translator.translation(forKey: "button.cancel.label")
            let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: nil)
            addAction(cancelAction)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        /// Add a translated delete action.
        func addDeleteAction(handler: ((UIAlertAction) -> Void)?) {
            let deleteText: String? = translator.translation(forKey: "button.delete.label")
            let action = UIAlertAction(title: deleteText, style: .destructive, handler: handler)
            addAction(action)
        }
    }
}
