import Foundation

protocol TranslationProvider {
	var translations: [Dictionary<String, String>] { get }
}
