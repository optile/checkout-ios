import Foundation

extension Input.Field.Validation {
    struct ExpiryDate {
        /// Return information if date is in future
        /// - Returns: nil if unable to construct a date (e.g. Strings are not numbers)
        static func isInFuture(expiryMonth: String, expiryYear: String) -> Bool? {
            var components = DateComponents()
            components.month = Int(expiryMonth)
            components.year = Int(expiryYear)
            
            let calendar = Calendar.current
            guard let expiryDate = calendar.date(from: components) else { return nil }
            
            let result = calendar.compare(expiryDate, to: Date(), toGranularity: .month)
            
            switch result {
            case .orderedAscending:
                // expiryDate is in the past
                return false
            default:
                // expiryDate is the same or in future
                return true
            }
        }
    }
}
