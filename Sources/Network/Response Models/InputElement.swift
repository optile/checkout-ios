import Foundation

public struct InputElement: Decodable {
	/// The name of the parameter represented by this input element.
	public let name: String
	
	/// Input type / restrictions that can and should be enforced by the client for this input element.
	public let type: Type
	
	/// Localized, human readable label that should be displayed for this input field.
	public let label: String
	
	/// Array of possible options for element of the `select` type.
	public let options: [SelectOption]?
	
	// MARK: - Enumerations
	
	public enum Type: String, Decodable {
		/// Ooe line of text without special restrictions
		case string
		
		/// numbers 0-9 and the delimiters space and dash ('-') are allowed
		case numeric
		
		/// numbers 0-9 only
		case integer
		
		/// a list of possible values given in an additional options attribute
		case select
		
		/// checkbox type, what allows `true` for set and `null` (or `false`) for non-set values
		case checkbox
	}
}
