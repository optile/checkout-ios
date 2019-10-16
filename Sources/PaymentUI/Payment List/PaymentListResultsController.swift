#if canImport(UIKit)
import Foundation
import UIKit

/// DataSource and Publisher for table view with payment list
class PaymentListResultsController: NSObject, UITableViewDataSource {
	@CurrentValue public var dataSource = [TableGroup]()
	
	weak var tableView: UITableView? {
		didSet {
			subscribeForDataSourceUpdate()
		}
	}
	
	private func subscribeForDataSourceUpdate() {
		// Reload table when datasource updated
		$dataSource.subscribe { [weak self] (oldNetworks, newNetworks) in
			DispatchQueue.main.async {
				self?.tableView?.reloadData()
				
				self?.unsubscribeFromImagesUpdate(in: oldNetworks)
				self?.subscribeForImagesUpdate(in: newNetworks)
			}
		}
	}
	
	private func unsubscribeFromImagesUpdate(in dataSource: [TableGroup]) {
		for group in dataSource {
			for network in group.networks {
				network.$logo.handler = nil
			}
		}
	}
	
	private func subscribeForImagesUpdate(in dataSource: [TableGroup]) {
		// Reload row when image updated
		for (section, group) in dataSource.enumerated() {
			for (row, network) in group.networks.enumerated() {
				network.$logo.subscribe { (_, _) in
					DispatchQueue.main.async {
						let indexPath = IndexPath(row: row, section: section)
						self.tableView?.reloadRows(at: [indexPath], with: .fade)
					}
				}
			}
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource[section].networks.count
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return dataSource.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let network = dataSource[indexPath.section].networks[indexPath.row]
		let cell = tableView.dequeueReusableCell(PaymentListTableViewCell.self, for: indexPath)
		cell.textLabel?.text = network.label
		cell.imageView?.image = network.logo
		return cell
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return dataSource[section].groupName
	}
}

// MARK: - TableGroup
extension PaymentListResultsController {
	class TableGroup {
		let groupName: String
		var networks = [PaymentNetwork]()
		
		init(groupName: String) {
			self.groupName = groupName
		}
	}
}
#endif
