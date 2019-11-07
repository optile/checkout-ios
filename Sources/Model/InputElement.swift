import Foundation

public class InputElement: NSObject, Decodable {
	/// The name of the parameter represented by this input element.
	public let name: String
	
	/// Input type / restrictions that can and should be enforced by the client for this input element.
	///
	/// Possible values: `string`, `numeric`, `integer`, `select`, `checkbox`
	public let type: String
	
	/// Localized, human readable label that should be displayed for this input field.
	public let label: String
	
	/// Array of possible options for element of the `select` type.
	public let options: [SelectOption]?
	
	// MARK: - Enumerations
	
	public var inputElementType: InputElementType? { InputElementType(rawValue: type) }
	
	public enum InputElementType: String, Decodable {
		case string, numeric, integer, select, checkbox
	}
}
