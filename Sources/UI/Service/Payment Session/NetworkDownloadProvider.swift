import Foundation


class NetworkDownloadProvider {
	let operationQueue = OperationQueue()
	
	func downloadData(from url: URL, completion: @escaping ((Result<Data, Error>) -> Void)) {
		let downloadRequest = DownloadData(from: url)
		let sendRequestOperation = SendRequestOperation(request: downloadRequest)
		sendRequestOperation.downloadCompletionBlock = completion
		operationQueue.addOperation(sendRequestOperation)
	}
}
