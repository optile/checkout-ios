import Foundation

// MARK: - Request

/// Retreives a payment session that was executed `LIST` operation.
public struct GetPaymentSession: APIRequest {
	public let body: Void
	public var path: String { return "pci/v1/" + longId }
	public let method: HTTPMethod = .GET
	public let queryItems = [
		URLQueryItem(name: "view", value: "jsonForms,-htmlForms")
		]
	
	// Variables
	public var longId: String
	
	/// - Parameter longId: Globally unique operation identifier assigned by OPG platform.
	public init(longId: String) {
		self.longId = longId
	}
	
	public typealias Response = PaymentSession
}

// MARK: - Response model

extension GetPaymentSession {
	public struct PaymentSession: Decodable {
		public let operationType: String
		public let networks: Networks
		
		public struct Networks: Decodable {
			public let applicable: [ApplicableNetwork]
		}
	}
}

// PaymentSession -> Networks
extension GetPaymentSession.PaymentSession.Networks {
	public struct ApplicableNetwork: Decodable {
		public let code, label, method, grouping, registration, recurrence, button: String
		public let links: [String: URL]
		public let localizedInputElements: [InputElement]

	}
}

// PaymentSession -> Networks -> ApplicableNetwork -> InputElement
extension GetPaymentSession.PaymentSession.Networks.ApplicableNetwork {
	public struct InputElement: Decodable {
		public let name, label: String
		public let type: InputType
		
		public enum InputType: String, Decodable {
			case numeric, string, select, integer
		}
	}
}
