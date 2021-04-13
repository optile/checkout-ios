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
}

extension Input.Table {
    class LayoutController: NSObject {
        let dataSource: DataSource
        weak var collectionView: UICollectionView!
        let flowLayout: UICollectionViewFlowLayout
        weak var inputTableControllerDelegate: InputTableControllerDelegate?

        internal init(dataSource: Input.Table.DataSource, collectionView: UICollectionView? = nil) {
            self.dataSource = dataSource
            self.collectionView = collectionView
            
            self.flowLayout = .init()
            flowLayout.minimumLineSpacing = .rowLineSpacing
        }
    }
}

extension Input.Table.LayoutController {
    
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
        return .init(top: .sectionSpacing / 2, left: 0, bottom: .sectionSpacing / 2, right: 0)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = dataSource.model[indexPath.section][indexPath.row]

        let availableWidth = collectionView.bounds.inset(by: collectionView.adjustedContentInset).width - collectionView.layoutMargins.left - collectionView.layoutMargins.right

        let frame = CGRect(origin: .zero, size: CGSize(width: availableWidth, height: UIView.layoutFittingCompressedSize.height))
        let cell = model.cellType.init(frame: frame)
        try? model.configure(cell: cell)

        let autoLayoutSize = cell.systemLayoutSizeFitting(frame.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)

        return autoLayoutSize
    }
}
