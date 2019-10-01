import Foundation

public struct ExtraElements: Decodable {
	/// Collection of extra elements (labels and checkboxes) that should be displayed on the top of payment page.
	public let properties: [ExtraElement]?
	
	/// Collection of extra elements (labels and checkboxes) that should be displayed on the bottom of payment page.
	public let bottom: [ExtraElement]?
}
