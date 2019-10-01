import Foundation
import struct API.PaymentSession.Interaction

// MARK: - Request

/// Retreives a payment session that was executed `LIST` operation.
public struct GetPaymentSession: Request {
	public let body: Void
	public var path: String { return "pci/v1/" + longId }
	public let method: HTTPMethod = .GET
	public let queryItems = [
		URLQueryItem(name: "view", value: "jsonForms,-htmlForms")
		]
	https://api.sandbox.oscato.com/pci/v1/5d91e367148b51017a982186l5ufp3vdu2lko4lkp5harann0h
	// Variables
	public var longId: String
	
	/// - Parameter longId: Globally unique operation identifier assigned by OPG platform.
	public init(longId: String) {
		self.longId = longId
	}
	
	public typealias Response = PaymentSession
}


public struct GetPaymentSession: Request {
	public let body: Void
	public var path: String { return "pci/v1/" + longId }
	public let method: HTTPMethod = .GET
	public let queryItems = [
		URLQueryItem(name: "view", value: "jsonForms,-htmlForms")
		]

	public var longId: String
	
	public typealias Response = ListResponse
}

// MARK: - Response model


// PaymentSession -> Networks
extension GetPaymentSession.PaymentSession.Networks {
	public struct ApplicableNetwork: Decodable {
		public let code, label, method, grouping, registration, recurrence, button: String
		public let links: [String: URL]
		public let localizedInputElements: [InputElement]

		public struct InputElement: Decodable {
			public let name, label: String
			public let type: InputType
			
			public enum InputType: String, Decodable {
				case numeric, string, select, integer
			}
		}
	}
}

// PaymentSession -> Networks -> ApplicableNetwork -> InputElement
extension GetPaymentSession.PaymentSession.Networks.ApplicableNetwork {

}



