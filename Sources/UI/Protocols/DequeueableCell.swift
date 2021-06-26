// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

#if canImport(UIKit)

import UIKit

protocol DequeueableCell: AnyObject {
    static var identifier: String { get }
}

extension DequeueableCell where Self: NSObject {
    static var identifier: String {
        return self.nameOfClass
    }
}

extension UITableView {
    func dequeueReusableCell<Cell>(_ cellClass: Cell.Type, for indexPath: IndexPath) -> Cell where Cell: DequeueableCell & UITableViewCell {
        // swiftlint:disable:next force_cast
        return self.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as! Cell
    }

    func register<Cell>(_ cellClass: Cell.Type) where Cell: DequeueableCell & UITableViewCell {
        self.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
    }
}

extension UICollectionView {
    func dequeueReusableCell<Cell>(_ cellClass: Cell.Type, for indexPath: IndexPath) -> Cell where Cell: DequeueableCell & UICollectionViewCell {
        // swiftlint:disable:next force_cast
        return self.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
    }

    func dequeueReusableCell(_ cellClass: (DequeueableCell & UICollectionViewCell).Type, for indexPath: IndexPath) -> UICollectionViewCell {
        return self.dequeueReusableCell(withReuseIdentifier: cellClass.identifier, for: indexPath)
    }

    func dequeueReusableSupplementaryView<Cell>(_ cellClass: Cell.Type, ofKind kind: String, for indexPath: IndexPath) -> Cell where Cell: DequeueableCell & UICollectionReusableView {
        // swiftlint:disable:next force_cast
        return self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
    }

    func register<Cell>(_ cellClass: Cell.Type) where Cell: DequeueableCell & UICollectionViewCell {
        self.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
    }

    func register<Cell>(_ cellClass: Cell.Type, forSupplementaryViewOfKind kind: String) where Cell: DequeueableCell & UICollectionReusableView {
        self.register(Cell.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: Cell.identifier)
    }
}

// MARK: - NSObject extension

private extension NSObject {
    class var nameOfClass: String {
        let fullClassName = NSStringFromClass(self)
        guard let className = fullClassName.components(separatedBy: ".").last else {
            assertionFailure("Using unexpected class name (full)")
            return fullClassName
        }

        return className
    }

    var nameOfClass: String {
        let fullClassName = NSStringFromClass(type(of: self))
        guard let className = fullClassName.components(separatedBy: ".").last else {
            assertionFailure("Using unexpected class name (full)")
            return fullClassName
        }

        return className
    }
}
#endif
