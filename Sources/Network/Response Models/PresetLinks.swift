import Foundation

public struct PresetLinks: Decodable {
	/// Link to 'close' initialized payment session with `CHARGE` operation.
	public let operation: URL
	
	/// URL of network logo (image) for preset account.
	public let logo: URL
}
