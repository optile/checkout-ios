import Foundation

struct PaymentError: LocalizedError {
	var localizedDescription: String
	var underlyingError: Error? = nil
	var errorDescription: String? { return localizedDescription}
}
