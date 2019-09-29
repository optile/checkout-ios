import Foundation

/// Protocol for all API requests, all requests have to conform it.
public protocol APIRequest {
	associatedtype Body
	associatedtype Response
	
	var path: String { get }
	var queryItems: [URLQueryItem] { get }
	var method: HTTPMethod { get }
	
	var body: Body { get }
	
	func decodeResponse(with data: Data?) throws -> Response
	func encodeBody() throws -> Data?
}

public extension APIRequest where Body: Encodable {
	func encodeBody() throws -> Data? {
		let encoder = JSONEncoder()
		return try encoder.encode(body)
	}
}

public extension APIRequest where Body == Void {
	func encodeBody() throws -> Data? {
		return nil
	}
}

public extension APIRequest where Response: Decodable {
	func decodeResponse(with data: Data?) throws -> Response {
		guard let data = data else {
			let error = APIError(description: "Server returned no data")
			throw error
		}
		
		let decoder = JSONDecoder()
		return try decoder.decode(Response.self, from: data)
	}
}

public extension APIRequest where Response == Void {
	func decodeResponse(with data: Data?) throws -> Response {
		return Void()
	}
}
