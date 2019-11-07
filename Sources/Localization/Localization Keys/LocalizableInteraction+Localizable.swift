import Foundation

extension LocalizableInteraction: Localizable {
	var localizableFields: [LocalizationKey<LocalizableInteraction>] {
		return [
			.init(\.localizedDescription, key: code + "." + reason)
		]
	}
}
