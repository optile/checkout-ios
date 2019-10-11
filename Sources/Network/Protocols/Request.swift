import Foundation

/// Base request protocol that will be used for `Connection`.
public protocol Request {
	associatedtype Response

	func decodeResponse(with data: Data?) throws -> Response
	func build() throws -> URLRequest
}

public extension Request where Response == Data {
	func decodeResponse(with data: Data?) throws -> Response {
		guard let data = data else {
			let error = InternalError(description: "Server returned no data")
			throw error
		}
		
		return data
	}
}

public extension Request where Response: Decodable {
	func decodeResponse(with data: Data?) throws -> Response {
		guard let data = data else {
			let error = InternalError(description: "Server returned no data")
			throw error
		}
		
		let decoder = JSONDecoder()
		return try decoder.decode(Response.self, from: data)
	}
}

public extension Request where Response == Void {
	func decodeResponse(with data: Data?) throws -> Response {
		return Void()
	}
}
