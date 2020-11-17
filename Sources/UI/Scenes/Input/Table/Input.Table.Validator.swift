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

        for section in dataSource.model {
            for row in section {
                guard let validatable = row as? Validatable else { continue }
                validatable.validateAndSaveResult(option: option)

                if validatable.validationErrorText != nil {
                    isValid = false
                }
            }
        }

        collectionView.reloadData()
        isSingleCellValidationEnabled = true

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
