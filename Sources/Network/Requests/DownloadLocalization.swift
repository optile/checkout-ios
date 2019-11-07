import Foundation

// MARK: - Request

/// Gets active LIST session details
///
/// Retrieves available payment capabilities for active `LIST` session.
/// Response model is `
public struct DownloadLocalization: GetRequest {
	public var url: URL
	let queryItems = [URLQueryItem]()
	public typealias Response = Dictionary<String, String>
	
	/// - Parameter url: `self` link from payment session
	public init(from url: URL) {
		self.url = url
	}
	
	public func decodeResponse(with data: Data?) throws -> Response {
		guard let data = data else {
			throw InternalError(description: "Localization file download error: no data was in a response")
		}
		
		guard let text = String(data: data, encoding: .isoLatin1) else {
			throw InternalError(description: "Unable to decode localization file: unable to decode a data fro isoLatin1")
		}
		
		var localization = Dictionary<String, String>()
		for line in text.components(separatedBy: .newlines) {
			let trimmedLine = line.trimmingCharacters(in: .whitespaces)
			let keyValueLine = trimmedLine.components(separatedBy: "=")
			guard keyValueLine.count == 2 else { continue }
			localization[keyValueLine[0]] = keyValueLine[1]
		}
		
		return localization
	}
}
