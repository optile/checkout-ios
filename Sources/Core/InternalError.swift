// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation
import os.log

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

    private let type: LogType
    private let staticDescription: StaticString
    private let arguments: [CVarArg]

    init(description: StaticString, type: LogType = .error, file: String = #file, line: Int = #line, function: String = #function, _ args: CVarArg...) {
        self.callStack = "Called from the file: " + file + "#" + String(line) + ", method: " + function
        self.staticDescription = description
        self.arguments = args
        self.type = type
    }

    init<T>(description: StaticString, type: LogType = .error, file: String = #file, line: Int = #line, function: String = #function, objects: T...) {
        self.callStack = "Called from the file: " + file + "#" + String(line) + ", method: " + function
        self.staticDescription = description

        var dumps = [String]()
        for object in objects {
            var text = String()
            dump(object, to: &text)
            dumps.append(text)
        }
        self.arguments = dumps

        self.type = type
    }

    func log() {
        if #available(iOS 14.0, *) {
            let logger = Logger(subsystem: Bundle.frameworkIdentifier, category: String(describing: Self.self))
            logger.error("⛔️ \(staticDescription, privacy: .private)")
        }
    }
}

extension String: Error {}
