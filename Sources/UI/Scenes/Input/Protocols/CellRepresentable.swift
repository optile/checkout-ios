// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

#if canImport(UIKit)
import UIKit

/// Could be represented as a table cell
protocol CellRepresentable: AnyObject {
    var isEnabled: Bool { get set }

    var cellType: (UICollectionViewCell & DequeueableCell).Type { get }
    func configure(cell: UICollectionViewCell) throws
}

// MARK: - Implementations

// If model is `TextInputField` & `DefinesKeyboardStyle`
extension CellRepresentable where Self: DefinesKeyboardStyle {
    var cellType: (UICollectionViewCell & DequeueableCell).Type { Input.Table.TextFieldViewCell.self }

    func configure(cell: UICollectionViewCell) throws {
        guard let textFieldCell = cell as? Input.Table.TextFieldViewCell else { throw errorForIncorrectView(cell) }
        textFieldCell.configure(with: self)
    }
}

extension CellRepresentable {
    func errorForIncorrectView(_ view: UIView) -> InternalError {
        return InternalError(description: "Unable to configure unexpected view: %@", view)
    }
}
#endif
