import Foundation

extension Input {
    /// A namespace with utilities to help automatically switch networks depending on account number.
    enum SmartSwitch {}
}

// MARK: - Rule

extension Input.SmartSwitch {
    /// Rule to detect network type based on regular expreession
    struct Rule: Decodable {
        /// Network code
        let code: String
        
        /// Regular expression
        let regex: String
    }
    
    fileprivate struct Root: Decodable {
        let items: [Rule]
    }
}

extension Sequence where Element == Input.SmartSwitch.Rule {
    /// First found rule with specified network code
    func first(withCode: String) -> Element? {
        for element in self where element.code == withCode {
            return element
        }
        
        return nil
    }
}

// MARK: - Provider

extension Input.SmartSwitch {
    /// Provides SmartSwitch rules
    class Provider {
        func getRules() throws -> [Rule] {
            let jsonString = RawProvider.groupsJSON
            guard let jsonData = jsonString.data(using: .utf8) else {
                throw InternalError(description: "Unable to encode string to data")
            }
            
            let root = try JSONDecoder().decode(Root.self, from: jsonData)
            return root.items
        }
    }
}

// MARK: - Selector

extension Input.SmartSwitch {
    class Selector {
        let networks: [Input.Network]
        private(set) var selected: DetectedNetwork

        init(networks: [Input.Network]) throws {
            self.networks = networks
            
            guard let firstNetwork = self.networks.first else {
                throw InternalError(description: "Tried to initialize with empty networks array")
            }
            
            if networks.count == 1 {
                // If only 1 network is present - it is always specific
                selected = .specific(firstNetwork)
            } else {
                // We don't know the account number for now, we will show the first network from an array
                selected = .generic(firstNetwork)
            }
        }
    }
}

extension Input.SmartSwitch.Selector {
    /// Find an appropriate network for the specified account number.
    func select(usingAccountNumber accountNumber: String) -> DetectedNetwork {
        if networks.count == 1 {
            // Keep specific network if only 1 network is in array
            return selected
        }
        
        let previouslySelected = selected
        
        defer {
            if previouslySelected.network != selected.network {
                moveInputValues(from: previouslySelected.network, to: selected.network)
            }
        }
        
        // Try to find a specific network
        for network in networks {
            guard let rule = network.switchRule else { continue }
            
            let isMatched = (accountNumber.range(of: rule.regex, options: .regularExpression) != nil)
            guard isMatched else { continue }
            
            selected = .specific(network)
            return selected
        }
        
        // Unable to find, return previously selected network as a generic one
        selected = .generic(previouslySelected.network)
        return selected
    }

    /// Move input values to a new network's input fields.
    private func moveInputValues(from oldNetwork: Input.Network, to newNetwork: Input.Network) {
        for (index, oldField) in oldNetwork.inputFields.enumerated() {
            newNetwork.inputFields[index].value = oldField.value
            oldField.value = nil
        }
    }

    enum DetectedNetwork: Equatable {
        /// Specific network wasn't detected, using a generic one
        case generic(Input.Network)
        
        /// Account number is valid for one of specific networks.
        /// - Note: that case is also used if only 1 network is present.
        case specific(Input.Network)
        
        var network: Input.Network {
            switch self {
            case .generic(let genericNetwork): return genericNetwork
            case .specific(let specificNetwork): return specificNetwork
            }
        }
    }
}
