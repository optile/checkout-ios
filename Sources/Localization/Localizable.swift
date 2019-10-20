import Foundation

/// Indicates that object is localizable
protocol Localizable {
	var localizableFields: [LocalizationKey<Self>] { get }
	var localeURL: URL? { get }
}

/// Structure that stores information about connection between model's keyPath with a key in a localization dictionary
/// - SeeAlso: `Localizable`
struct LocalizationKey<T> {
	let field: WritableKeyPath<T, String>
	let key: String
	
	init(_ field: WritableKeyPath<T, String>, key: String) {
		self.field = field
		self.key = key
	}
}
