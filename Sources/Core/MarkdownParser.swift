// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import UIKit

private let textExpression = "\\[(?<text>[^\\]]*)\\]"
private let urlExpression = "\\((?<url>[^\\)]*)\\)"
private let linkExpression = textExpression + urlExpression

struct MarkdownParser {
    func parse(_ input: String) -> NSAttributedString {
        let output = NSMutableAttributedString(string: input)

        for link in parseLinks(in: input) {
            guard let linkRange = output.string.range(of: link.string) else { continue }
            output.replaceCharacters(in: NSRange(linkRange, in: output.string), with: link.attributedString)
        }

        return output
    }
}

// MARK: - Parsing

extension MarkdownParser {
    func parseLinks(in input: String) -> [Link] {
        do {
            let regex = try NSRegularExpression(pattern: linkExpression)

            let matches = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))

            return matches.compactMap { match in
                guard let linkRange = Range(match.range, in: input) else { return nil }
                let linkString = String(input[linkRange])
                return Link(string: linkString)
            }
        } catch {
            print("Failed to parse links: \(error)")
            return []
        }
    }
}

// MARK: - Link

extension MarkdownParser {
    struct Link {
        let string: String
        let text: String
        let url: URL

        init?(string: String) {
            // Parse text
            guard let textRange = string.range(of: textExpression, options: .regularExpression) else { return nil }
            let text = string[textRange].dropFirst().dropLast()

            // Parse URL
            guard let urlRange = string.range(of: urlExpression, options: .regularExpression) else { return nil }
            let urlString = string[urlRange].dropFirst().dropLast()
            guard let url = URL(string: String(urlString)) else { return nil }

            self.string = string
            self.text = String(text)
            self.url = url
        }

        var attributedString: NSAttributedString {
            NSAttributedString(string: text, attributes: [.link: url])
        }
    }
}
