#if canImport(UIKit)
import UIKit

/// Could be represented as a table cell
protocol CellRepresentable {
    func dequeueCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell & ContainsInputCellDelegate
    func configure(cell: UITableViewCell)
}

// If model is `TextInputField` & `DefinesKeyboardStyle`
extension CellRepresentable where Self: DefinesKeyboardStyle {
    func dequeueCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell & ContainsInputCellDelegate {
        let cell = tableView.dequeueReusableCell(Input.Table.TextFieldViewCell.self, for: indexPath)
        cell.indexPath = indexPath
        return cell
    }
    
    func configure(cell: UITableViewCell) {
        guard let cell = cell as? Input.Table.TextFieldViewCell else { return }
        cell.configure(with: self)
    }
}
#endif
