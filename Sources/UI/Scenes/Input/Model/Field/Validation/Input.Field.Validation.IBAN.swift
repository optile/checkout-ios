import Foundation

extension Input.Field.Validation {
    struct IBAN {
        static func isValid(iban: String) -> Bool {
            let max = 999999999
            let modulus = 97
            
            let ibanWithoutSpaces = iban.remove(charactersIn: .whitespaces)
            
            if ibanWithoutSpaces.count < 5 {
                 return false
            }
            
            let characters: [Character] = Array(ibanWithoutSpaces)
            let ibanWithSwappedCharacters = characters.dropFirst(4) + characters.prefix(4)
            
            var total = 0
            
            for character in ibanWithSwappedCharacters {
                guard let characterAlphabetPosition = Int(String(character), radix: 36) else {
                    return false
                }
                
                total = (characterAlphabetPosition > 9 ? total * 100 : total * 10) + characterAlphabetPosition
                
                if total > max {
                    total = total % modulus
                }
            }
            
            return (total % modulus == 1)
        }
    }
}
