import Foundation

public class PresetLinks: NSObject, Decodable {
	/// Link to 'close' initialized payment session with `CHARGE` operation.
	public let operation: URL
	
	/// URL of network logo (image) for preset account.
	public let logo: URL
}
