import Foundation

public class Checkbox: NSObject, Decodable {
	/// Distinguish name of this checkbox element.
	public let name: String
	
	/// Operating and display mode of this checkbox.
	public let mode: String
	
	/// Display label for the checkbox.
	public let label: String?
	
	/// Error message that will be displayed if checkbox is required, but was not checked.
	public let requireMsg: String?
}
