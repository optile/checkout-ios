import Foundation

public struct ExtraElement: Decodable {
	/// Descriptive text that should be displayed for this extra element.
	public let text: String?
	
	/// Checkbox parameters, 'null' if this extra element is a label.
	public let checkbox: Checkbox?
}
