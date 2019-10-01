import Foundation

public struct Status {
	/// Status code describes operation current state. See list of all [Status Codes](https://www.optile.io/opg#285186).
	public let code: String
	
	/// Reason of this status, complements status code and has more detailed granularity. See list of all [Status Codes](https://www.optile.io/opg#285186).
	public let reason: String
}
