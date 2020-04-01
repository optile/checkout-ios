#if canImport(UIKit)
import UIKit

extension Input.Table {
    /// Acts as a datasource and delegate for input table views and responds on delegate events from a table and cells.
    /// - Note: We use custom section approach (sections are presented as rows `SectionHeaderCell`) because we have to use `.plain` table type to get correct `tableView.contentSize` calculations and plain table type has floating sections that we don't want, so we switched to sections as rows.
    /// - See also: `DataSourceElement`
    class Controller: NSObject {
        var network: Input.Network {
            didSet {
                networkDidUpdate(new: network, old: oldValue)
            }
        }
        
        unowned let tableView: UITableView
        private var dataSource: [DataSourceElement]
        weak var inputChangesListener: InputValueChangesListener?
        
        enum DataSourceElement {
            case row(CellRepresentable)
            
            /// Separator acts as delimiter and section divider
            case separator
        }
        
        init(for network: Input.Network, tableView: UITableView) {
            self.network = network
            self.tableView = tableView
            self.dataSource = Self.arrangeBySections(network: network)
            
            super.init()
            
            network.submitButton.buttonDidTap = { [weak self] _ in
                self?.validateFields(option: .fullCheck)
            }
        }
        
        func registerCells() {
            tableView.register(TextFieldViewCell.self)
            tableView.register(CheckboxViewCell.self)
            tableView.register(ButtonCell.self)
            tableView.register(SectionHeaderCell.self)
        }
        
        @discardableResult
        func becomeFirstResponder() -> Bool {
            for cell in tableView.visibleCells {
                guard cell.canBecomeFirstResponder else { continue }
                
                cell.becomeFirstResponder()
                return true
            }
            
            return false
        }
        
        func validateFields(option: Input.Field.Validation.Option) {
            // We need to resign a responder to avoid double validation after `textFieldDidEndEditing` event (keyboard will disappear on table reload).
            tableView.endEditing(true)
            
            for cell in dataSource {
                guard case let .row(cellRepresentable) = cell else { continue }
                guard let validatable = cellRepresentable as? Validatable else { continue }
                
                validatable.validateAndSaveResult(option: option)
            }
            
            tableView.reloadData()
        }
        
        private func networkDidUpdate(new: Input.Network, old: Input.Network) {
            guard !network.inputFields.isEmpty else {
                tableView.reloadData()
                return
            }
            
            let oldDataSource = dataSource
            let newDataSource = Self.arrangeBySections(network: new)
            
            guard newDataSource.count == oldDataSource.count else {
                tableView.endEditing(true)
                self.dataSource = newDataSource
                tableView.reloadData()
                becomeFirstResponder()
                
                return
            }
            
            for visibleIndexPath in tableView.indexPathsForVisibleRows ?? [] {
                guard let cell = tableView.cellForRow(at: visibleIndexPath) else { continue }
                guard case let .row(cellRepresentable) = dataSource[visibleIndexPath.row] else { continue }
                
                cellRepresentable.configure(cell: cell)
            }
        }
        
        /// Arrange models by sections
        private static func arrangeBySections(network: Input.Network) -> [DataSourceElement] {
            var sections = [[CellRepresentable]]()
            
            // Input Fields
            let inputFields = network.inputFields.filter {
                if let field = $0 as? InputField, field.isHidden { return false }
                return true
            }
            sections += [inputFields]
            
            // Checkboxes
            var checkboxes = [CellRepresentable]()
            for field in network.separatedCheckboxes where !field.isHidden {
                checkboxes.append(field)
            }

            sections += [checkboxes]

            // Submit
            sections += [[network.submitButton]]

            // Add separators
            var dataSource = [DataSourceElement]()
            for section in sections where !section.isEmpty {
                let rows: [DataSourceElement] = section.map { .row($0) }
                dataSource.append(contentsOf: rows)
                dataSource.append(.separator)
            }
            
            // Remove last separator
            if let lastElement = dataSource.last, case .separator = lastElement {
                dataSource.removeLast()
            }
            
            return dataSource
        }
    }
}

// MARK: - UITableViewDataSource

extension Input.Table.Controller: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dataSource[indexPath.row] {
        case .separator: return Input.Table.SectionHeaderCell.dequeue(by: tableView, for: indexPath)
        case .row(let cellRepresentable):
            let cell = cellRepresentable.dequeueCell(for: tableView, indexPath: indexPath)
            cell.tintColor = tableView.tintColor
            cell.selectionStyle = .none
            cellRepresentable.configure(cell: cell)
            
            if let input = cell as? ContainsInputCellDelegate {
                input.delegate = self
            }
            
            return cell
        }
     }
}


extension Input.Table.Controller: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource[indexPath.row] {
        case .separator: return Input.Table.SectionHeaderCell.Constant.height
        case .row(let cell): return cell.estimatedHeightForRow
        }
    }
}

// MARK: - InputCellDelegate

extension Input.Table.Controller: InputCellDelegate {
    func inputCellDidEndEditing(at indexPath: IndexPath) {
        guard case let .row(cellRepresentable) = dataSource[indexPath.row] else { return }
        guard let validatableRow = cellRepresentable as? Validatable else { return }
        
        validatableRow.validateAndSaveResult(option: .preCheck)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func inputCellBecameFirstResponder(at indexPath: IndexPath) {
        // Don't show an error text when input field is focused
        guard case let .row(cellRepresentable) = dataSource[indexPath.row] else { return }
        
        if let validatableModel = cellRepresentable as? Validatable, validatableModel.validationErrorText != nil {
            validatableModel.validationErrorText = nil
            
            tableView.beginUpdates()
            
            switch tableView.cellForRow(at: indexPath) {
            case let textFieldViewCell as Input.Table.TextFieldViewCell:
                textFieldViewCell.showValidationResult(for: validatableModel)
            default: break
            }
            
            tableView.endUpdates()
        }
        
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
    
    func inputCellValueDidChange(to newValue: String?, at indexPath: IndexPath) {
        guard case let .row(cellRepresentable) = dataSource[indexPath.row] else { return }
        guard let inputField = cellRepresentable as? InputField else { return }
        
        inputField.value = newValue ?? ""
        inputChangesListener?.valueDidChange(for: inputField)
    }
}
#endif
