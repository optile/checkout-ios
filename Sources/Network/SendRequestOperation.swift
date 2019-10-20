import Foundation

public class SendRequestOperation<T>: AsynchronousOperation where T: Request {
	let connection: Connection
	public let request: T
	
	public var downloadCompletionBlock: ((Result<T.Response, Error>) -> Void)?
	
	public init(connection: Connection, request: T) {
		self.connection = connection
		self.request = request
		super.init()
	}
	
	public convenience init(request: T) {
		let connection = URLSessionConnection()
		self.init(connection: connection, request: request)
	}
	
	public override func main() {
		connection.send(request: request) { result in
			switch result {
			case .success(let data):
				do {
					let decodedResponse = try self.request.decodeResponse(with: data)
					self.downloadCompletionBlock?(.success(decodedResponse))
				} catch {
					self.downloadCompletionBlock?(.failure(error))
				}
			case .failure(let error):
				self.downloadCompletionBlock?(.failure(error))
			}
			
			self.finish()
		}
	}
}
