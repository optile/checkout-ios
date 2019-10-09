import Foundation
import os

func log(_ type: OSLogType, _ message: StaticString, _ args: CVarArg...) {
	if #available(iOS 12.0, *) {
		os_log(type, message, args)
	} else {
		print("\(message). Arguments has been <redacted>")
	}
}
