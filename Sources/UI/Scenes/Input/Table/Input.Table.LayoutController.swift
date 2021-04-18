// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

private extension CGFloat {
    /// Spacing between rows in section
    static var rowLineSpacing: CGFloat { return 8 }

    /// Spacing between sections
    static var sectionSpacing: CGFloat { return 24 }

    /// Spacing between sections
    static var interitemSpacing: CGFloat { return 20 }
}

extension Input.Table {
    class LayoutController: NSObject {
        let dataSource: DataSource
        weak var collectionView: UICollectionView!
        let flowLayout: UICollectionViewFlowLayout
        weak var inputTableControllerDelegate: InputTableControllerDelegate?
        
        var maxCellHeight: CGFloat = 0

        internal init(dataSource: Input.Table.DataSource, collectionView: UICollectionView? = nil) {
            self.dataSource = dataSource
            self.collectionView = collectionView
            
            self.flowLayout = .init()
            flowLayout.minimumInteritemSpacing = .interitemSpacing
            flowLayout.minimumLineSpacing = .rowLineSpacing
        }
    }
}

extension Input.Table.LayoutController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        inputTableControllerDelegate?.scrollViewWillBeginDragging(scrollView)
    }
}

extension Input.Table.LayoutController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: .sectionSpacing / 2, left: collectionView.layoutMargins.left, bottom: .sectionSpacing / 2, right: collectionView.layoutMargins.right)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var currentCellSize = size(forItemAt: indexPath, in: collectionView)
        if !isHalfWidthCell(at: indexPath) {
            return currentCellSize
        }

        // Make equal heights for half-width rows

        var maxHeight: CGFloat = 0

        let models = dataSource.model[indexPath.section]

        // Size for the next row
        let nextIndexPath = indexPath.nextRow
        if models.isElementExists(at: nextIndexPath.row), isHalfWidthCell(at: nextIndexPath) {
            let cellSize = size(forItemAt: nextIndexPath, in: collectionView)
            if cellSize.height > maxHeight {
                maxHeight = cellSize.height
            }
        }

        // Size for the previous row
        let previousIndexPath = indexPath.previousRow
        if models.isElementExists(at: previousIndexPath.row), isHalfWidthCell(at: previousIndexPath) {
            let cellSize = size(forItemAt: previousIndexPath, in: collectionView)
            if cellSize.height > maxHeight {
                maxHeight = cellSize.height
            }
        }

        if currentCellSize.height < maxHeight {
            currentCellSize.height = maxHeight
        }

        return currentCellSize
    }

    private func size(forItemAt indexPath: IndexPath, in collectionView: UICollectionView) -> CGSize {
        let model = dataSource.model[indexPath.section][indexPath.row]

        let availableWidth = collectionView.bounds.inset(by: collectionView.adjustedContentInset).width
        let cellWidth: CGFloat

        if isHalfWidthCell(at: indexPath) {
            // -1 was added to compatability with previous iOS versions, summary value for 2 cells should be less than available width, not equal
            cellWidth = (availableWidth - collectionView.layoutMargins.left - collectionView.layoutMargins.right - .interitemSpacing) / 2 - 1
        } else {
            // Add left and right spacing
            cellWidth = availableWidth - collectionView.layoutMargins.left - collectionView.layoutMargins.right
        }

        let frame = CGRect(origin: .zero, size: CGSize(width: cellWidth, height: UIView.layoutFittingCompressedSize.height))
        let cell = model.cellType.init(frame: frame)
        try? model.configure(cell: cell)

        let autoLayoutSize = cell.systemLayoutSizeFitting(frame.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)

        return autoLayoutSize
    }

    /// Half-width cells are expiry date and verification code cells following each other
    private func isHalfWidthCell(at indexPath: IndexPath) -> Bool {
        var isExpiryDatePresent = false
        var isVerificationCodePresent = false
        var halfWidthItemsPosition = [Int]()

        for i in dataSource.model[indexPath.section].enumerated() {
            if i.element is Input.Field.ExpiryDate {
                isExpiryDatePresent = true
                halfWidthItemsPosition.append(i.offset)
            }
            if i.element is Input.Field.VerificationCode {
                isVerificationCodePresent = true
                halfWidthItemsPosition.append(i.offset)
            }
        }

        // If that item needs custom width
        guard halfWidthItemsPosition.contains(indexPath.row) else { return false }

        // If expiry and verification fields are present
        guard isExpiryDatePresent && isVerificationCodePresent else { return false }

        // Check that we have exactly 2 items, also out of bounds fatal error protection for the next `guard`
        guard halfWidthItemsPosition.count == 2 else { return false }

        // Check that items follow each other
        guard (halfWidthItemsPosition[1] - halfWidthItemsPosition[0] == 1) else { return false }

        return true
    }
}

private extension BidirectionalCollection {
    func isElementExists(at index: Index) -> Bool {
        return indices.contains(index)
    }
}

private extension IndexPath {
    /// Returns the next row
    /// - Warning: return doesn't guarantee that row exists, you should check it before accessing it.
    var nextRow: IndexPath {
        IndexPath(row: row + 1, section: section)
    }

    /// Returns the previous row
    /// - Warning: return doesn't guarantee that row exists, you should check it before accessing it.
    var previousRow: IndexPath {
        IndexPath(row: row - 1, section: section)
    }
}
