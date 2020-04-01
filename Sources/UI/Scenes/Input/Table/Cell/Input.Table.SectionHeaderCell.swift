import UIKit

extension Input.Table {
    class SectionHeaderCell: UITableViewCell, DequeueableTableCell {
        struct Constant {
            static var height: CGFloat { return 4 }
        }
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)

            NSLayoutConstraint.activate([
                contentView.heightAnchor.constraint(equalToConstant: Constant.height)
            ])
         }
         
         required init?(coder: NSCoder) {
             fatalError("init(coder:) has not been implemented")
         }
    }
}
