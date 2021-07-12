// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

#if canImport(UIKit)
import Foundation
import UIKit

extension List.Table {
    class BorderedCell: UITableViewCell {
        weak var leftBorder: UIView!
        weak var rightBorder: UIView!
        weak var topBorder: UIView!
        weak var bottomBorder: UIView!

        weak var customAccessoryView: UIView!
        weak var customContentView: UIView!

        var cellIndex: CellIndex = .middle {
            didSet { cellIndexDidChange() }
        }

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)

            self.preservesSuperviewLayoutMargins = true

            addBordersViews()
            addCustomAccessoryView()
            addCustomContentView()
            addSelectedBackgroundView()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension List.Table.BorderedCell {
    enum CellIndex {
        case first
        case middle
        case last

        /// It is an only one cell in section
        case singleCell
    }
}

// MARK: - Views

extension List.Table.BorderedCell {
    fileprivate func cellIndexDidChange() {
        switch cellIndex {
        case .first:
            topBorder.backgroundColor = .themedTableBorder
            bottomBorder.backgroundColor = .themedTableBorder
            bottomBorder.isHidden = true
        case .middle:
            topBorder.backgroundColor = .themedTableCellSeparator
            bottomBorder.backgroundColor = .themedTableCellSeparator
            bottomBorder.isHidden = true
        case .last:
            topBorder.backgroundColor = .themedTableCellSeparator
            bottomBorder.backgroundColor = .themedTableBorder
            bottomBorder.isHidden = false
        case .singleCell:
            topBorder.backgroundColor = .themedTableBorder
            bottomBorder.backgroundColor = .themedTableBorder
            bottomBorder.isHidden = false
        }
    }

    fileprivate func addBordersViews() {
        let leftBorder = UIView(frame: .zero)
        self.leftBorder = leftBorder

        let rightBorder = UIView(frame: .zero)
        self.rightBorder = rightBorder

        let topBorder = UIView(frame: .zero)
        self.topBorder = topBorder

        let bottomBorder = UIView(frame: .zero)
        self.bottomBorder = bottomBorder
        bottomBorder.isHidden = true

        for border in [leftBorder, rightBorder, topBorder, bottomBorder] {
            border.translatesAutoresizingMaskIntoConstraints = false
            border.backgroundColor = .themedTableBorder
            contentView.addSubview(border)
        }

        NSLayoutConstraint.activate([
            leftBorder.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            leftBorder.topAnchor.constraint(equalTo: topAnchor),
            leftBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
            leftBorder.widthAnchor.constraint(equalToConstant: .separatorWidth),

            rightBorder.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            rightBorder.topAnchor.constraint(equalTo: topAnchor),
            rightBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
            rightBorder.widthAnchor.constraint(equalToConstant: .separatorWidth),

            topBorder.topAnchor.constraint(equalTo: topAnchor),
            topBorder.leadingAnchor.constraint(equalTo: leftBorder.leadingAnchor),
            topBorder.trailingAnchor.constraint(equalTo: rightBorder.trailingAnchor),
            topBorder.heightAnchor.constraint(equalToConstant: .separatorWidth),

            bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBorder.leadingAnchor.constraint(equalTo: leftBorder.leadingAnchor),
            bottomBorder.trailingAnchor.constraint(equalTo: rightBorder.trailingAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: .separatorWidth)
        ])
    }

    private func addSelectedBackgroundView() {
        let selectedBackgroundView = UIView(frame: .zero)
        selectedBackgroundView.backgroundColor = .clear
        self.selectedBackgroundView = selectedBackgroundView

        let viewWithPaddings = UIView(frame: .zero)
        viewWithPaddings.backgroundColor = .themedTableCellSeparator
        selectedBackgroundView.addSubview(viewWithPaddings)

        viewWithPaddings.translatesAutoresizingMaskIntoConstraints = false
        selectedBackgroundView.preservesSuperviewLayoutMargins = true

        NSLayoutConstraint.activate([
            viewWithPaddings.leadingAnchor.constraint(equalTo: selectedBackgroundView.layoutMarginsGuide.leadingAnchor),
            viewWithPaddings.topAnchor.constraint(equalTo: selectedBackgroundView.topAnchor),
            viewWithPaddings.bottomAnchor.constraint(equalTo: selectedBackgroundView.bottomAnchor),
            viewWithPaddings.trailingAnchor.constraint(equalTo: selectedBackgroundView.layoutMarginsGuide.trailingAnchor)
        ])
    }

    fileprivate func addCustomContentView() {
        let customContentView = UIView(frame: .zero)
        self.customContentView = customContentView
        customContentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(customContentView)

        NSLayoutConstraint.activate([
            customContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customContentView.leadingAnchor.constraint(equalTo: leftBorder.leadingAnchor),
            customContentView.trailingAnchor.constraint(equalTo: customAccessoryView.trailingAnchor, constant: -16),
            customContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    fileprivate func addCustomAccessoryView() {
        let customAccessoryView = UIImageView(frame: .zero)
        customAccessoryView.contentMode = .scaleAspectFit
        customAccessoryView.image = AssetProvider.disclosureIndicator
        customAccessoryView.tintColor = .themedTableBorder
        self.customAccessoryView = customAccessoryView
        customAccessoryView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(customAccessoryView)

        NSLayoutConstraint.activate([
            customAccessoryView.topAnchor.constraint(equalTo: topAnchor),
            customAccessoryView.trailingAnchor.constraint(equalTo: rightBorder.trailingAnchor, constant: -16),
            customAccessoryView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Constants

private extension CGFloat {
    static var separatorWidth: CGFloat { return 1 }
    static var cornerRadius: CGFloat { return 2 }
}
#endif
