import Foundation

extension Input.Field {
    enum Validation {}
}

// MARK: - Model

extension Input.Field.Validation {
    struct Options: OptionSet {
        let rawValue: Int

        static let valueExists = Options(rawValue: 1 << 0)
        static let validValue  = Options(rawValue: 1 << 1)
        static let maxLength   = Options(rawValue: 1 << 2)
        
        static let all: Options = [.valueExists, .validValue, .maxLength]
    }
    
    enum Result {
        case success
        case failure(ValidationError)
    }
    
    enum ValidationError: Error {
        case missingValue
        case invalidValue
        case incorrectLength
    }
    
    // MARK: Decodable models
    
    /// Network with validation rules for input fields
    struct Network: Decodable {
        /// Network code
        let code: String
        let items: [Rule]
    }
    
    /// Rule to check input field value
    struct Rule: Decodable {
        /// Input element's name
        let type: String
        
        /// Regular expression
        let regex: String
        
        let maxLength: Int?
    }
}

extension Sequence where Element == Input.Field.Validation.Network {
    /// First found network with specified network code
    func first(withCode: String) -> Element? {
        for element in self where element.code == withCode {
            return element
        }
        
        return nil
    }
}

extension Sequence where Element == Input.Field.Validation.Rule {
    /// First found rule with specified type code
    func first(withType: String) -> Element? {
        for element in self where element.type == withType {
            return element
        }
        
        return nil
    }
}

// MARK: - Provider

extension Input.Field.Validation {
    class Provider {
        func get() throws -> [Network] {
            guard let jsonData = RawProvider.validationsJSON.data(using: .utf8) else {
                throw InternalError(description: "Couldn't make a JSON data from a validation JSON string")
            }
            
            let networks = try JSONDecoder().decode([Network].self, from: jsonData)
            return networks
        }
    }
}
