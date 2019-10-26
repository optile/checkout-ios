import Foundation

struct LocalizableError: Retryable {
	private(set) var localizedDescription: String = String()
	var isRetryable: Bool
	
	var localizationKey: LocalTranslation

	var underlyingError: Error?
	
	init(localizationKey: LocalTranslation, isRetryable: Bool = false) {
		self.localizationKey = localizationKey
		self.isRetryable = isRetryable
	}
}

extension LocalizableError: LocalizedError {
	var errorDescription: String? { localizedDescription }
}

extension LocalizableError: Localizable {
	var localeURL: URL? { return nil }
	
	var localizableFields: [LocalizationKey<LocalizableError>] {
		[
			.init(\.localizedDescription, key: localizationKey.rawValue)
		]
	}
}

protocol Retryable {
	var isRetryable: Bool { get }
}
