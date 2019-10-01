import Foundation

public struct OperationType: Decodable {
	/// Types of possible operations.
	public let type: OperationTypeEnum?
	
	// MARK: - Enumerations
	
	public enum OperationTypeEnum: String, Decodable {
		case CHARGE, PRESET, PAYOUT, UPDATE
	}
}
