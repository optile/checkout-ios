import Foundation

struct LocalizableInteraction {
	let code: String
	let reason: String

	var localizedDescription: String = String()
}

extension LocalizableInteraction: Localizable {
	var localizableFields: [LocalizationKey<LocalizableInteraction>] {
		return [
			.init(\.localizedDescription, key: code + "." + reason, fallbackKey: LocalTranslation.errorDefault.rawValue)
		]
	}
}

extension Interaction {
	var localizable: LocalizableInteraction {
		.init(code: code, reason: reason)
	}
}
