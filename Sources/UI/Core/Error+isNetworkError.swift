import Foundation

extension Error {
	var isNetworkError: Bool {
		let nsError = self as NSError
		
		let allowedCodes: [URLError.Code] = [.notConnectedToInternet, .dataNotAllowed]
		let allowedCodesNumber = allowedCodes.map { $0.rawValue }
		if nsError.domain == NSURLErrorDomain, allowedCodesNumber.contains(nsError.code) {
			return true
		} else {
			return false
		}
	}
}
