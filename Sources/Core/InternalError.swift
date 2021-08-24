// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation

struct InternalError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    var debugDescription: String { return String(format: staticDescription.description, arguments) }
    var description: String {
        var redactedArguments = [CVarArg]()
        for _ in 0...arguments.count {
            redactedArguments.append("<redacted>")
        }

        return String(format: staticDescription.description, redactedArguments)
    }
    let callStack: String

    private let staticDescription: StaticString
    private let arguments: [CVarArg]

    init(description: StaticString, file: String = #file, line: Int = #line, function: String = #function, _ args: CVarArg...) {
        self.callStack = "Called from the file: " + file + "#" + String(line) + ", method: " + function
        self.staticDescription = description
        self.arguments = args
    }

    init<T>(description: StaticString, file: String = #file, line: Int = #line, function: String = #function, objects: T...) {
        self.callStack = "Called from the file: " + file + "#" + String(line) + ", method: " + function
        self.staticDescription = description

        var dumps = [String]()
        for object in objects {
            var text = String()
            dump(object, to: &text)
            dumps.append(text)
        }
        self.arguments = dumps
    }

    func log() {
        if #available(iOS 14.0, *) {
            logger.error("⛔️ \(staticDescription, privacy: .private)")
        }
    }
}

extension InternalError: Loggable {}
extension String: Error {}
