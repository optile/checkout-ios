import Foundation

class DataDownloadProvider {
	let operationQueue = OperationQueue()
	let connection: Connection
	
	init(connection: Connection) {
		self.connection = connection
	}
	
	func downloadData(from url: URL, completion: @escaping ((Result<Data, Error>) -> Void)) {
		let downloadRequest = DownloadData(from: url)
		let sendRequestOperation = SendRequestOperation(connection: connection, request: downloadRequest)
		sendRequestOperation.downloadCompletionBlock = completion
		operationQueue.addOperation(sendRequestOperation)
	}
}
