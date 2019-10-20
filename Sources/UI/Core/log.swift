import Foundation
import os

func log(_ type: LogType, _ message: StaticString, _ args: CVarArg...) {
	if #available(iOS 12.0, OSX 10.14, *) {
		os_log(type.osLogType, message, args)
	} else {
		print("\(message). Arguments has been <redacted>")
	}
}


enum LogType {
	case info, debug, error, fault
	
	@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
	fileprivate var osLogType: OSLogType {
		switch self {
		case .debug: return OSLogType.debug
		case .error: return OSLogType.error
		case .fault: return OSLogType.fault
		case .info: return OSLogType.info
		}
	}
}
