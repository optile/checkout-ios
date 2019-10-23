import Foundation

/// Customized `Request` with a path, body and method.
//protocol CustomRequest: Request {
//	associatedtype Body
//	
//	var path: String { get }
//	var queryItems: [URLQueryItem] { get }
//
//	var method: HTTPMethod { get }
//	var body: Body { get }
//	
//	func encodeBody() throws -> Data?
//}
//
//extension CustomRequest {
//	func build(endpoint: URL) throws -> URLRequest {
//		var components = URLComponents()
//		
//		components.scheme = endpoint.scheme
//		components.host = endpoint.host
//		components.path = endpoint.path + "/" + path
//		components.queryItems = queryItems
//		
//		guard let url = components.url else {
//			throw NetworkInternalError(description: "Internal error, unable to make API request URL")
//		}
//		
//		var urlRequest = URLRequest(url: url)
//		urlRequest.httpMethod = method.rawValue
//		urlRequest.httpBody = try encodeBody()
//		
//		return urlRequest
//	}
//}
//
//extension CustomRequest where Body: Encodable {
//	func encodeBody() throws -> Data? {
//		let encoder = JSONEncoder()
//		return try encoder.encode(body)
//	}
//}
//
//extension CustomRequest where Body == Void {
//	func encodeBody() throws -> Data? {
//		return nil
//	}
//}
