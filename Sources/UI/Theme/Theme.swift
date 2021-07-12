// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

@objc public class Theme: NSObject {
    @objc public var font: UIFont?

    @objc public var backgroundColor: UIColor
    @objc public var tableBorder: UIColor
    @objc public var tableCellSeparator: UIColor

    @objc public var textColor: UIColor
    @objc public var detailTextColor: UIColor
    @objc public var buttonTextColor: UIColor

    @objc public var tintColor: UIColor
    @objc public var errorTextColor: UIColor

    /// - Parameters:
    ///   - font: `nil` is used for default system font
    @objc public init(font: UIFont? = nil, backgroundColor: UIColor, tableBorder: UIColor, tableCellSeparator: UIColor, textColor: UIColor, detailTextColor: UIColor, buttonTextColor: UIColor, tintColor: UIColor, errorTextColor: UIColor) {
        // swiftlint:disable:previous line_length
        self.font = font
        self.backgroundColor = backgroundColor
        self.tableBorder = tableBorder
        self.tableCellSeparator = tableCellSeparator
        self.textColor = textColor
        self.detailTextColor = detailTextColor
        self.buttonTextColor = buttonTextColor
        self.tintColor = tintColor
        self.errorTextColor = errorTextColor
    }
}

public extension Theme {
    @objc static var shared: Theme = .standard

    @objc static var standard: Theme {
        let textColor = UIColor(white: 66.0 / 255.0, alpha: 1.0)
        let detailedTextColor = UIColor(white: 143.0 / 255.0, alpha: 1.0)
        let tintColor = UIColor(red: 0.0, green: 137.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0)
        let border = UIColor(white: 224.0 / 255.0, alpha: 1.0)
        let separator = UIColor(white: 242.0 / 255.0, alpha: 1.0)
        let errorColor = UIColor(red: 205, green: 0, blue: 0, alpha: 1.0)

        let backgroundColor: UIColor
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }

        return Theme(
            font: nil,
            backgroundColor: backgroundColor,
            tableBorder: border,
            tableCellSeparator: separator,
            textColor: textColor,
            detailTextColor: detailedTextColor,
            buttonTextColor: .white,
            tintColor: tintColor,
            errorTextColor: errorColor
        )
    }
}

internal extension UIColor {
    static var themedText: UIColor {
        return Theme.shared.textColor
    }

    static var themedDetailedText: UIColor {
        return Theme.shared.detailTextColor
    }

    static var themedButtonTextColor: UIColor {
        return Theme.shared.buttonTextColor
    }

    static var themedTint: UIColor {
        return Theme.shared.tintColor
    }

    static var themedBackground: UIColor {
        return Theme.shared.backgroundColor
    }

    static var themedTableBorder: UIColor {
        return Theme.shared.tableBorder
    }

    static var themedTableCellSeparator: UIColor {
        return Theme.shared.tableCellSeparator
    }

    static var themedError: UIColor {
        return Theme.shared.errorTextColor
    }
}

internal extension UIFont {
    static func preferredThemeFont(forTextStyle textStyle: TextStyle) -> UIFont {
        if let customFont = Theme.shared.font {
            return customFont.withSize(forTextStyle: textStyle)
        } else {
            return UIFont.preferredFont(forTextStyle: textStyle)
        }
    }

    private func withSize(forTextStyle textStyle: TextStyle) -> UIFont {
        let size = UIFont.preferredFont(forTextStyle: textStyle).pointSize
        return self.withSize(size)
    }
}
