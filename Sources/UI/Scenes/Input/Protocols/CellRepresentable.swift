#if canImport(UIKit)
import UIKit

/// Could be represented as a table cell
protocol CellRepresentable {
    func dequeueCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func configure(cell: UITableViewCell)
    
    var estimatedHeightForRow: CGFloat { get }
}

// If model is `TextInputField` & `DefinesKeyboardStyle`
extension CellRepresentable where Self: DefinesKeyboardStyle {
    func dequeueCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(Input.Table.TextFieldViewCell.self, for: indexPath)
        cell.indexPath = indexPath
        return cell
    }
    
    func configure(cell: UITableViewCell) {
        guard let cell = cell as? Input.Table.TextFieldViewCell else { return }
        cell.configure(with: self)
    }
    
    var estimatedHeightForRow: CGFloat { 95.5 }
}

extension CellRepresentable where Self == Input.Field.Checkbox {
    func dequeueCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(Input.Table.CheckboxViewCell.self, for: indexPath)
        cell.indexPath = indexPath
        return cell
    }
    
    func configure(cell: UITableViewCell) {
        guard let cell = cell as? Input.Table.CheckboxViewCell else { return }
        cell.configure(with: self)
    }
    
    var estimatedHeightForRow: CGFloat { 53 }
}
#endif
