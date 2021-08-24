// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

extension Input.Table {
    class DataSource: NSObject {
        weak var inputCellDelegate: InputCellDelegate?
        weak var cvvHintDelegate: CVVTextFieldViewCellDelegate?

        fileprivate(set) var model: [[CellRepresentable]] = .init()

        func setModel(network: Input.Network, header: CellRepresentable) {
            model = Self.arrangeBySections(networkUIModel: network.uiModel, header: header)
        }

        func isLastTextField(at indexPath: IndexPath) -> Bool {
            var lastTextFieldRow: Int?

            let rowsInSection = model[indexPath.section]
            for rowIndex in indexPath.row...rowsInSection.count - 1 {
                let element = rowsInSection[rowIndex]
                guard element as? TextInputField != nil else { continue }
                lastTextFieldRow = rowIndex
            }

            if lastTextFieldRow == nil { return true }
            if lastTextFieldRow == indexPath.row { return true }

            return false
        }

        /// Set enabled state for all datasource items
        func setEnabled(_ enabled: Bool) {
            for cellRepresentable in model.flatMap({ $0 }) {
                cellRepresentable.isEnabled = enabled
            }
        }

        func setPaymentButtonState(isLoading: Bool) {
            for cellRepresentable in model.flatMap({ $0 }) {
                guard let buttonModel = cellRepresentable as? Input.Field.Button else { continue }
                buttonModel.isActivityIndicatorAnimating = isLoading
                return
            }
        }

        var inputFields: [InputField] {
            model.flatMap {
                $0.compactMap { $0 as? InputField }
            }
        }

        /// Arrange models by sections
        private static func arrangeBySections(networkUIModel: Input.Network.UIModel, header: CellRepresentable) -> [[CellRepresentable]] {
            var sections = [[CellRepresentable]]()

            // Header
            sections += [[header]]

            // Input Fields
            sections += [
                networkUIModel.inputFields.compactMap {
                    // Don't add to view non representable input fields
                    guard let cell = $0 as? CellRepresentable else { return nil }
                    return cell
                }
            ]

            // Checkboxes, each checkbox in a separate section
            var checkboxes = [CellRepresentable]()
            for field in networkUIModel.separatedCheckboxes {
                guard let cellRepresentable = field as? CellRepresentable else { continue }
                checkboxes += [cellRepresentable]
            }

            checkboxes.sort {
                // Labels is always on the bottom
                func order(for field: Any) -> Int {
                    switch field {
                    case is Input.Field.Label: return 1
                    default: return 0
                    }
                }

                return order(for: $0) < order(for: $1)
            }

            sections += checkboxes.map { [$0] }

            // Submit
            if let submitButton = networkUIModel.submitButton {
                sections += [[submitButton]]
            }

            let dataSource = sections.filter { !$0.isEmpty }

            return dataSource
        }
    }
}

// MARK: - UICollectionViewDataSource

extension Input.Table.DataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return model.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellModel = model[indexPath.section][indexPath.row]
        let cell = collectionView.dequeueReusableCell(cellModel.cellType, for: indexPath)
        cell.tintColor = collectionView.tintColor

        do {
            try cellModel.configure(cell: cell)
        } catch {
            if #available(iOS 14.0, *) {
                error.log(to: logger)
            }
        }

        if let cell = cell as? ContainsInputCellDelegate {
            cell.delegate = inputCellDelegate
        }

        if let cell = cell as? SupportsPrimaryAction {
            let isLastRow = isLastTextField(at: indexPath)
            let action: PrimaryAction = isLastRow ? .done : .next
            cell.setPrimaryAction(to: action)
        }

        if let cvvCell = cell as? Input.Table.CVVTextFieldViewCell {
            cvvCell.cvvDelegate = cvvHintDelegate
        }

        return cell
    }
}

// MARK: - Input.Table.DataSource.Diff

extension Input.Table.DataSource {
    struct Diff {
        var old: [[CellRepresentable]]
        var new: [[CellRepresentable]]
    }
}

extension Input.Table.DataSource.Diff {
    func applyChanges(for collectionView: UICollectionView) {
        for oldSectionIndex in 0 ..< old.count {
            // Ensure that old section is still will be present in a new model or delete old one
            guard oldSectionIndex < new.count else {
                collectionView.deleteSections([oldSectionIndex])
                continue
            }

            reload(section: oldSectionIndex, in: collectionView)
        }

        // If a new model has more sections insert new ones
        if new.count > old.count {
            for index in old.count - 1 ..< new.count - 1 {
                collectionView.insertSections([index])
            }
        }
    }

    private func reload(section: Int, in collectionView: UICollectionView) {
        // If number of cells in section are not equal reload a whole section
        guard old[section].count == new[section].count else {
            collectionView.reloadSections([section])
            return
        }

        for rowIndex in 0 ..< old.count {
            let indexPath = IndexPath(row: rowIndex, section: section)

            guard let cell = collectionView.cellForItem(at: indexPath) else { continue }

            let model = new[section][rowIndex]

            if type(of: cell) == model.cellType {
                do {
                    // Configure old cell with a new model
                    try model.configure(cell: cell)
                    cell.layoutIfNeeded()
                } catch {
                    // Programmatic error in `configure()` method of model because it should accept that type because of `type(of:)` check above
                    let internalError = InternalError(description: "Unable to configure cell: %@", error.localizedDescription)
                    internalError.log()

                    collectionView.reloadItems(at: [indexPath])
                }
            } else {
                collectionView.reloadItems(at: [indexPath])
            }
        }
    }
}

extension Input.Table.DataSource: Loggable {
    var logCategory: String { "InputScene" }
}
