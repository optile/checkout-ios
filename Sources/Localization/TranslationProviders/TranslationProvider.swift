// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

protocol TranslationProvider: Loggable {
    var translations: [[String: String]] { get }

    func translation(forKey key: String) -> String
    func translation(forKey key: String) -> String?
}

extension TranslationProvider {
    /// Find a translation for a key
    /// - Returns: translation or key if translation wasn't found
    func translation(forKey key: String) -> String {
        if let translation = translation(forKey: key) {
            return translation
        } else {
            if #available(iOS 14.0, *) {
                logger.error("Localization for key \(key, privacy: .private) is not found")
            }

            return key
//            return String()
        }
    }

    /// Find a translation for a key
    /// - Returns: translation or `nil` if translation wasn't found
    func translation(forKey key: String) -> String? {
        for dictionary in translations {
            guard let translation = dictionary[key] else { continue }
            return translation
        }

        return nil
    }
}
