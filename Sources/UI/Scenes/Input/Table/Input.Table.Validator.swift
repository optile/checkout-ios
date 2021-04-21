// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

extension Input.Table {
    class Validator {
        let dataSource: DataSource
        weak var collectionView: UICollectionView!

        /// If disabled single cell validation will be skipped.
        /// - Note: goal of that property is to avoid double validation animation bug when a text field looses a focus after user presses a pay button, so `validate(cell:)` and `validateAll` could be called at one time.
        /// Property is modified by `validateAll` method.
        fileprivate var isSingleCellValidationEnabled: Bool = true

        init(dataSource: DataSource) {
            self.dataSource = dataSource
        }
    }
}

extension Input.Table.Validator {
    func removeValidationError(for cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }

        let cellRepresentable = dataSource.model[indexPath.section][indexPath.row]

        if let validatableModel = cellRepresentable as? Validatable, validatableModel.validationErrorText != nil {
            validatableModel.validationErrorText = nil

            // Update cell's view if cell is on the screen
            if let textFieldViewCell = collectionView.cellForItem(at: indexPath) as? Input.Table.TextFieldViewCell {
                textFieldViewCell.showValidationResult(for: validatableModel)
                invalidateLayout(at: [indexPath])
            }
        }
    }

    /// Validate all models and display validation results in cells
    /// - Returns: is all fields are valid
    @discardableResult func validateAll(option: Input.Field.Validation.Option) -> Bool {
        // We need to resign a responder to avoid double validation after `textFieldDidEndEditing` event (keyboard will disappear on table reload).
        isSingleCellValidationEnabled = false
        collectionView.endEditing(true)

        var isValid = true

        for (sectionNumber, section) in dataSource.model.enumerated() {
            for (rowNumber, row) in section.enumerated() {
                // Update validation model
                guard let validatable = row as? Validatable else { continue }
                validatable.validateAndSaveResult(option: option)

                if validatable.validationErrorText != nil {
                    isValid = false
                }

                // Update cells
                // We update each cell separately, because if we just use `.reloadData()` something goes wrong with Material TextFields lessOrEqual constraint and error text fields will be positioned incorrectly
                let indexPath = IndexPath(row: rowNumber, section: sectionNumber)
                guard let cell = collectionView.cellForItem(at: indexPath) else { continue }
                let cellRepresentable = dataSource.model[indexPath.section][indexPath.row]

                do {
                    try cellRepresentable.configure(cell: cell)
                } catch {
                    log(error)
                }
            }
        }

        collectionView.collectionViewLayout.invalidateLayout()

        self.isSingleCellValidationEnabled = true

        return isValid
    }

    func validate(cell: UICollectionViewCell) {
        guard isSingleCellValidationEnabled else { return }
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }

        let cellRepresentable = dataSource.model[indexPath.section][indexPath.row]
        guard let validatableRow = cellRepresentable as? Validatable else { return }

        let previousValidationErrorText = validatableRow.validationErrorText

        // Validate an input and update a model
        validatableRow.validateAndSaveResult(option: .preCheck)

        // Display validation result if cell is visible
        if previousValidationErrorText != validatableRow.validationErrorText, let cell = collectionView.cellForItem(at: indexPath) {
            do {
                try cellRepresentable.configure(cell: cell)
                invalidateLayout(at: [indexPath])
            } catch {
                log(error)
            }
        }
    }

    /// Invalidates layout at specified index paths with animation.
    /// Used to update cell's height for displaying multiline error messages.
    private func invalidateLayout(at indexPaths: [IndexPath]) {
        let context = UICollectionViewFlowLayoutInvalidationContext()
        context.invalidateItems(at: indexPaths)

        collectionView.performBatchUpdates({
            self.collectionView.collectionViewLayout.invalidateLayout(with: context)
        }, completion: nil)
    }
}
