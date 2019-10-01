import Foundation

public struct Checkbox: Decodable {
	/// Distinguish name of this checkbox element.
	public let name: String
	
	/// Operating and display mode of this checkbox.
	public let mode: Mode
	
	/// Display label for the checkbox.
	public let label: String?
	
	/// Error message that will be displayed if checkbox is required, but was not checked.
	public let requireMsg: String?
	
	// MARK: - Enumerations
	
	public enum Mode: String, Decodable {
		case OPTIONAL, OPTIONAL_PRESELECTED, REQUIRED, REQUIRED_PRESELECTED, FORCED, FORCED_DISPLAYED
	}
}
