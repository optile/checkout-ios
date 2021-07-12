// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

extension List.Table {
    final class GroupingService {}
}

extension List.Table.GroupingService {
    private func get() throws -> [Rule] {
        let groupingData = try AssetProvider.getGroupingRulesData()

        let core = try JSONDecoder().decode(Core.self, from: groupingData)
        return core.items
    }

    func group(networks: [PaymentNetwork]) -> [[PaymentNetwork]] {
        do {
            let rules = try get()
            let groupedNetworks = networks.grouped(using: rules)
            return groupedNetworks
        } catch {
            // Grouping service was unable to return rules, skip grouping
            return networks.map { [$0] }
        }
    }

   // MARK: - Model

    private struct Core: Decodable {
        let items: [Rule]
    }

    struct Rule: Decodable {
        let code: String
        let regex: NSRegularExpression

        enum CodingKeys: String, CodingKey {
            // swiftlint:disable:previous nesting
            case code, regex
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            code = try container.decode(String.self, forKey: .code)

            let regexString = try container.decode(String.self, forKey: .regex)
            regex = try NSRegularExpression(pattern: regexString, options: [])
        }
    }
}

// MARK: - Grouping extension

private extension Sequence where Element == PaymentNetwork {
    func grouped(using rules: [List.Table.GroupingService.Rule]) -> [[PaymentNetwork]] {
        var ungroupedNetworks = [PaymentNetwork]()
        var groupedNetworks = [PaymentNetwork]()

        for network in self {
            let isGroupingAllowed = (rules.first(withCode: network.applicableNetwork.code) != nil)

            if isGroupingAllowed {
                // Check if input elements are equal
                if let firstNetwork = groupedNetworks.first {
                    guard firstNetwork.applicableNetwork.inputElements == network.applicableNetwork.inputElements else {
                        // Input elements are not equal, don't group that network
                        ungroupedNetworks.append(network)
                        continue
                    }
                }

                groupedNetworks.append(network)
            } else {
                ungroupedNetworks.append(network)
            }
        }

        var groupedResult = ungroupedNetworks.map { [$0] }
        groupedResult.append(groupedNetworks)

        return groupedResult
    }
}

private extension Sequence where Element == List.Table.GroupingService.Rule {
    func first(withCode: String) -> Element? {
        for item in self where item.code == withCode {
            return item
        }

        return nil
    }
}

// MARK: - InputElement equality check

extension InputElement {
    override public func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? InputElement else { return false }

        return (
            name == rhs.name &&
            type == rhs.type &&
            options == rhs.options
        )
    }
}

extension SelectOption {
    override public func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? SelectOption else { return false }

        return (
            value == rhs.value &&
            selected == rhs.selected
        )
    }
}
