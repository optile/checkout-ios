// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

#if canImport(UIKit)
import UIKit
import Foundation

extension List.Table {
    final class DataSource: NSObject {
        private let sections: [Section]
        private let translationProvider: TranslationProvider
        private let operationType: PaymentSession.Operation

        init(networks: [PaymentNetwork], accounts: [RegisteredAccount]?, translation: SharedTranslationProvider, genericLogo: UIImage, operationType: PaymentSession.Operation) {
            self.translationProvider = translation
            self.operationType = operationType

            var sections = [Section]()

            // Fill accounts
            if let accounts = accounts {
                var rows = [AccountRow]()
                for account in accounts {
                    let row = AccountRow(account: account)
                    rows.append(row)
                }

                let accountSection = Section.accounts(rows: rows)
                sections.append(accountSection)
            }

            // Fill networrks
            let groupedNetworks = GroupingService().group(networks: networks)

            var singleRows = [SingleNetworkRow]()
            var detailedRows = [GroupedNetworkRow]()

            for networks in groupedNetworks {
                guard !networks.isEmpty else { continue }

                if networks.count == 1, let network = networks.first {
                    let row = SingleNetworkRow(network: network)
                    singleRows.append(row)
                } else {
                    let row = GroupedNetworkRow(networks: networks, genericLogo: genericLogo)
                    detailedRows.append(row)
                }
            }
            let networkSection = Section.networks(rows: detailedRows + singleRows)
            sections.append(networkSection)

            // Don't display empty sections
            self.sections = sections.filter {
                switch $0 {
                case .accounts(let rows): return !rows.isEmpty
                case .networks(let rows): return !rows.isEmpty
                }
            }
        }

        func logo(for indexPath: IndexPath) -> LoadableLogo? {
            switch sections[indexPath.section] {
            case .accounts(let accountRows): return accountRows[indexPath.row]
            case .networks(let networkRows): return networkRows[indexPath.row] as? LoadableLogo
            }
        }

        func model(for indexPath: IndexPath) -> Model {
            switch sections[indexPath.section] {
            case .accounts(let accountRows): return .account(accountRows[indexPath.row].account)
            case .networks(let networkRows): return .network(networkRows[indexPath.row].networks)
            }
        }
    }
}

extension List.Table.DataSource {
    enum Model {
        case network([PaymentNetwork])
        case account(RegisteredAccount)
    }
}

// MARK: UITableViewDataSource

extension List.Table.DataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .accounts(let accounts): return accounts.count
        case .networks(let networks): return networks.count
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (sections[section], operationType) {
        case (.accounts, .CHARGE): return translationProvider.translation(forKey: "accounts.title")
        case (.accounts, .UPDATE): return translationProvider.translation(forKey: "accounts.update.title")
        case (.networks, .CHARGE): return translationProvider.translation(forKey: "networks.title")
        case (.networks, .UPDATE): return translationProvider.translation(forKey: "networks.update.title")
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row: DequeuableRow

        switch sections[indexPath.section] {
        case .accounts(let rows): row = rows[indexPath.row]
        case .networks(let rows): row = rows[indexPath.row]
        }

        return row.dequeueConfiguredReusableCell(for: tableView, at: indexPath)
    }
}

// MARK: - Table's model

extension List.Table.DataSource {
    fileprivate enum Section {
        case accounts(rows: [AccountRow])
        case networks(rows: [NetworkRow])
    }
}

// MARK: - Protocols

private protocol DequeuableRow {
    func dequeueConfiguredReusableCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
}

private protocol NetworkRow: DequeuableRow {
    var networks: [PaymentNetwork] { get }
}

private protocol SingleLabelRow: DequeuableRow {
    var label: String { get }
    var image: UIImage? { get }
}

extension SingleLabelRow {
    func dequeueConfiguredReusableCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(List.Table.SingleLabelCell.self, for: indexPath)

        // Set model
        cell.networkLabel?.text = label
        cell.networkLogoView?.image = image

        // Set cell position
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)

        if numberOfRows == 1 {
            cell.cellIndex = .singleCell
        } else {
            switch indexPath.row {
            case let row where row == 0: cell.cellIndex = .first
            case let row where row == numberOfRows - 1: cell.cellIndex = .last
            default: cell.cellIndex = .middle
            }
        }

        return cell
    }
}

// MARK: Extensions to model

extension List.Table.DataSource.AccountRow: SingleLabelRow {}
extension List.Table.DataSource.SingleNetworkRow: SingleLabelRow, NetworkRow {}
extension List.Table.DataSource.GroupedNetworkRow: NetworkRow {}

#endif
