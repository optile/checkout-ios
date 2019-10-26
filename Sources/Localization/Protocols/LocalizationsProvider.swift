import Foundation

protocol LocalizationsProvider {
	var translations: [Dictionary<String, String>] { get }
}
