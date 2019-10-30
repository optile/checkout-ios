import Foundation

struct PaymentError: LocalizedError, Retryable {
	var localizedDescription: String
	var isRetryable: Bool = false
	
	var underlyingError: Error? = nil

	var errorDescription: String? { return localizedDescription}
}
