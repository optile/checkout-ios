// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

extension Input.Field.Validation {
    /// Linear search for card-number-like substrings in a given input string.
    /// Used for catching accidental input of credit card numbers into the holder name field.
    /// A card-number-like string is a sequence of digits, possibly separated by an arbitrary number of
    /// whitespaces, dashes and/or dots, that contains at least 11 digits, e.g.:
    ///
    /// Examples:
    ///   * 12345678901
    ///   * 1234 5678 9012 3456
    ///   * 1234-5678-9012-3456
    ///   * 1234.5678.9012.3456
    class CardNumberMatcher {
        private let numberOfDigitsToMatch = 11
        private let separators: [Character] = ["-", "."]
    }
}

extension Input.Field.Validation.CardNumberMatcher {
    func containsCardNumber(in input: String) -> Bool {
        var sequentialNumbersCount = 0

        for character in input {
            if character.isNumber {
                // Increase sequential numbers counter
                sequentialNumbersCount += 1
                if sequentialNumbersCount == numberOfDigitsToMatch { return true }
            } else if isSeparator(character: character) {
                // Numbers could contain unlimited number of separators between them
                continue
            } else {
                // It is not number, and not a separator, reset sequential counter
                sequentialNumbersCount = 0
            }
        }

        return false
    }

    private func isSeparator(character: Character) -> Bool {
        return character.isWhitespace || separators.contains(character)
    }
}
