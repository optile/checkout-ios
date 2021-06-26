// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

// Based on https://github.com/luximetr/AnyFormatKit (MIT License)
// Based on commit: fe937c1e83574ad66f87f4a3eedc592440304077

import Foundation

class CaretPositionCorrector {
    let textPattern: String
    let patternSymbol: Character

    init(textPattern: String, patternSymbol: Character) {
        self.textPattern = textPattern
        self.patternSymbol = patternSymbol
    }

    /// Find and correct of new caret position
    /// - Parameters:
    ///   - range: range of characters in textInput, that will replaced
    ///   - replacementFiltered: filtered string, that will replace characters in range
    func calculateCaretPositionOffset(originalRange range: NSRange, replacementFiltered: String) -> Int {
        var offset = 0
        if replacementFiltered.isEmpty {
            offset = offsetForRemove(current: range.location)
        } else {
            offset = offsetForInsert(from: range.location, replacementLength: replacementFiltered.count)
        }
        return offset
    }

    /// Find indexes of patterns symbols in range
    /// - Parameter searchRange: range in string for searching indexes
    /// - Returns: array of indexes of characters, that equal to patternSymbol in textPattern
    private func indexesOfPatternSymbols(in searchRange: Range<String.Index>) -> [String.Index] {
        var indexes: [String.Index] = []
        var tempRange = searchRange
        while let range = textPattern.range(
            of: String(patternSymbol), options: .caseInsensitive, range: tempRange, locale: nil) {
                tempRange = range.upperBound..<tempRange.upperBound
                indexes.append(range.lowerBound)
        }
        return indexes
    }

    /// Calculate offset for caret, when characters will remove
    /// - Parameter location: current location of caret
    /// - Returns: offset for caret from beginning of textPattern while remove characters in textInput
    private func offsetForRemove(current location: Int) -> Int {
        let startIndex = textPattern.startIndex
        let searchRange = startIndex..<textPattern.index(startIndex, offsetBy: location)
        let indexes = indexesOfPatternSymbols(in: searchRange)

        if let lastIndex = indexes.last {
            // return lastIndex.encodedOffset + 1
            return lastIndex.utf16Offset(in: textPattern) + 1
        }
        return 0
    }

    /// Calculate offset for caret, when characters will insert
    /// - Parameters:
    ///   - location: current location of caret
    ///   - replacementLength: length of replacement string
    /// - Returns: offset for caret from beginning of textPattern while insert characters in textInput
    private func offsetForInsert(from location: Int, replacementLength: Int) -> Int {
        let startIndex = textPattern.index(textPattern.startIndex, offsetBy: location)
        let searchRange = startIndex..<textPattern.endIndex
        let indexes = indexesOfPatternSymbols(in: searchRange)

        if replacementLength <= indexes.count {
            return textPattern.distance(from: textPattern.startIndex, to: indexes[replacementLength - 1]) + 1
        } else {
            return textPattern.distance(from: textPattern.startIndex, to: textPattern.endIndex)
        }
    }
}
