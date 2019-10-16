#if canImport(UIKit)

import UIKit

protocol DequeueableTableCell where Self: UITableViewCell {
	static var identifier: String { get }
}

extension DequeueableTableCell {
	static var identifier: String {
		return self.nameOfClass
	}
}

extension DequeueableTableCell {
	typealias View = UITableView
    
    static func dequeue(by view: View, for indexPath: IndexPath) -> Self {
        return view.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Self
    }
}

private extension NSObject {
    class var nameOfClass: String {
		let fullClassName = NSStringFromClass(self)
		guard let className = fullClassName.components(separatedBy: ".").last else {
			// FIXME: Remove in production
			assertionFailure("Using unexpected class name (full)")
			return fullClassName
		}
        
		return className
    }

    var nameOfClass: String {
		let fullClassName = NSStringFromClass(type(of: self))
		guard let className = fullClassName.components(separatedBy: ".").last else {
			// FIXME: Remove in production
			assertionFailure("Using unexpected class name (full)")
			return fullClassName
		}
        
		return className
    }
}

extension UITableView {
	func dequeueReusableCell<Cell>(_ cellClass: Cell.Type, for indexPath: IndexPath) -> Cell where Cell: DequeueableTableCell {
		return self.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as! Cell
	}
	
	func register<Cell>(_ cellClass: Cell.Type) where Cell: DequeueableTableCell {
		self.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
	}
}

#endif
