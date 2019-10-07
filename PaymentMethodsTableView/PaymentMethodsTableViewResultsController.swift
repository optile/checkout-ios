#if canImport(UIKit)
import Foundation
import UIKit

class PaymentMethodsTableViewResultsController: NSObject, UITableViewDataSource {
	@CurrentValue public var dataSource = [TableGroup]()
	weak var tableView: UITableView?
	
	override init() {
		super.init()
		
		$dataSource.subscribe { [weak tableView] networks in
			DispatchQueue.main.async {
				tableView?.reloadData()
			}
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource[section].networks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let network = dataSource[indexPath.section].networks[indexPath.row]
		let cell = tableView.dequeueReusableCell(PaymentMethodsTableViewCell.self, for: indexPath)
		cell.textLabel?.text = network.label
		return cell
	}
	

}

// MARK: - TableGroup
extension PaymentMethodsTableViewResultsController {
	class TableGroup {
		let groupName: String
		var networks = [PaymentNetwork]()
		
		init(groupName: String) {
			self.groupName = groupName
		}
	}
}
#endif
