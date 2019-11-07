import Foundation

/// Simple request that just performs `GET` request on specified URL.
/// - Note: `queryItems` will always override items from the `url`
protocol GetRequest: Request {
	var queryItems: [URLQueryItem] { get }
	var url: URL { get }
}

extension GetRequest {
	public func build() throws -> URLRequest {
		guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
			throw InternalError(description: "Internal error, incorrect GetRequest URL")
		}
		
		if !queryItems.isEmpty {
			components.queryItems = queryItems
		}
		
		guard let url = components.url else {
			throw InternalError(description: "Internal error, unable to make API request URL")
		}
		
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = HTTPMethod.GET.rawValue
		
		return urlRequest
	}
}
