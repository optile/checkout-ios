#if canImport(UIKit)
import UIKit

extension Input.Table {
    /// Acts as a datasource for input table views and responds on delegate events from a table and cells.
    class Controller: NSObject {
        var network: Input.Network {
            didSet {
                networkDidUpdate()
            }
        }
        
        unowned let tableView: UITableView
        private var cells: [CellRepresentable & InputField]
        weak var inputChangesListener: InputValueChangesListener?
        
        init(for network: Input.Network, tableView: UITableView) {
            self.network = network
            self.tableView = tableView
            self.cells = network.inputFields
            super.init()
        }
        
        func validateFields(options: Input.Field.Validation.Options) {
            // We need to resign a responder to avoid double validation after `textFieldDidEndEditing` event (keyboard will disappear on table reload).
            tableView.endEditing(true)
            
            for cell in cells {
                guard let validatable = cell as? Validatable else { continue }
                validatable.validateAndSaveResult(options: options)
            }
            
            tableView.reloadData()
        }
        
        private func networkDidUpdate() {
            cells = network.inputFields

            guard !cells.isEmpty else {
                tableView.reloadData()
                return
            }
            
            for (index, cell) in tableView.visibleCells.enumerated() {
                cells[index].configure(cell: cell)
            }
        }
    }
}

extension Input.Table.Controller: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellRepresentable = cells[indexPath.row]
        let cell = cellRepresentable.dequeueCell(for: tableView, indexPath: indexPath)
        cellRepresentable.configure(cell: cell)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
     }
}

extension Input.Table.Controller: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = tableView.cellForRow(at: indexPath)
        row?.becomeFirstResponder()
    }
}

extension Input.Table.Controller: InputCellDelegate {
    func inputCellDidEndEditing(at indexPath: IndexPath) {
        guard let model = cells[indexPath.row] as? Validatable else { return }
        
        model.validateAndSaveResult(options: [.validValue, .maxLength])
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func inputCellBecameFirstResponder(at indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
    
    func inputCellValueDidChange(to newValue: String?, at indexPath: IndexPath) {
        let model = cells[indexPath.row]
        model.value = newValue
        
        inputChangesListener?.valueDidChange(for: model)
    }
}
#endif
