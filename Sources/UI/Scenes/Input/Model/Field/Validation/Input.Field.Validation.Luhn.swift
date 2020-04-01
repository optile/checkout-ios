import Foundation

extension Input.Field.Validation {
    struct Luhn {
        static func isValid(accountNumber: String) -> Bool {
            let accountNumberWithoutSpace = accountNumber.remove(charactersIn: .whitespaces)
            
            var sum = 0
            let digitStrings = accountNumberWithoutSpace.reversed().map { String($0) }

            for tuple in digitStrings.enumerated() {
                if let digit = Int(tuple.element) {
                    let odd = tuple.offset % 2 == 1

                    switch (odd, digit) {
                    case (true, 9):
                        sum += 9
                    case (true, 0...8):
                        sum += (digit * 2) % 9
                    default:
                        sum += digit
                    }
                } else {
                    return false
                }
            }
            return sum % 10 == 0
        }
    }
}
