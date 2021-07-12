// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

// MARK: - Constants

private extension CGSize {
    /// Size of a cell with network's logo, image would be automatically scaled.
    /// - TODO: Change to dynamic size to support accessibility better
    static var cellSize: CGSize { return .init(width: 39, height: 24) }
}

private extension String {
    static var cellIdentifier: String { return "Input.Table.ImageViewCell" }
}

// MARK: -

extension Input.Table {
    class ImagesCollectionViewController: NSObject {
        var dataSource = [Input.Network]()

        func registerCells(for collectionView: UICollectionView) {
            collectionView.register(Input.Table.ImageViewCell.self, forCellWithReuseIdentifier: .cellIdentifier)
        }
    }
}

extension Input.Table.ImagesCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .cellIdentifier, for: indexPath) as? Input.Table.ImageViewCell else {
            assertionFailure("Unexpected cell")
            return UICollectionViewCell(frame: .zero)
        }
        cell.imageView.image = dataSource[indexPath.row].uiModel.logo
        return cell
    }
}

extension Input.Table.ImagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .cellSize
    }
}
