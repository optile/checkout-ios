import Foundation

/// Indicates that object is localizable
protocol Localizable {
	var localizableFields: [LocalizationKey<Self>] { get }
}

/// Structure that stores information about connection between model's keyPath with a key in a localization dictionary
/// - SeeAlso: `Localizable`
struct LocalizationKey<T> {
	/// Field where localization will be writteen
	let field: WritableKeyPath<T, String>
	
	/// Localization key that would be used by a provider to lookup a translation string
	let key: String
	
	init(_ field: WritableKeyPath<T, String>, key: String) {
		self.field = field
		self.key = key
	}
}
