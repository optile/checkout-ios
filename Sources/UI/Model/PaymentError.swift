import Foundation

struct PaymentError: LocalizedError, Retryable {
	var localizedDescription: String
	var isRetryable: Bool = false

	var errorDescription: String? { return localizedDescription}
}
