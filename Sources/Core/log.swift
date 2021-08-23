// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

import Foundation
import os.log

func log(_ type: LogType, _ message: StaticString, _ args: CVarArg...) {
    if #available(iOS 14.0, *) {
        let logger = Logger(subsystem: Bundle.frameworkIdentifier, category: "Log")
        logger.log(level: type.osLogType, "\(message, privacy: .private)")
    }
}

func log(_ error: Error) {
    // Log errors
    if let internalError = error as? InternalError {
        internalError.log()
        return
    }

    var text = String()
    dump(error, to: &text)
    log(.error, "%@", text)
}

@available(iOS 14.0, *)
extension Error {
    func log(to logger: Logger) {
        var text = String()
        dump(self, to: &text)
        logger.error("\(text)")
    }
}

enum LogType {
    case info, debug, error, fault

    @available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    var osLogType: OSLogType {
        switch self {
        case .debug: return OSLogType.debug
        case .error: return OSLogType.error
        case .fault: return OSLogType.fault
        case .info: return OSLogType.info
        }
    }
}
