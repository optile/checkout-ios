import Foundation

struct PaymentError: LocalizedError {
	var localizedDescription: String
	var isRetryable: Bool = false
	
	var underlyingError: Error? = nil

	var errorDescription: String? { return localizedDescription}
}
