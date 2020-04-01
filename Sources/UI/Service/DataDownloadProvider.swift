import Foundation

class DataDownloadProvider {
    let operationQueue = OperationQueue()
    let connection: Connection

    init(connection: Connection) {
        self.connection = connection
    }

    func downloadData(for models: [ContainsLoadableData], completion: @escaping () -> Void) {
        // Final operation that would call completion block
        let completionOperation = BlockOperation {
            completion()
        }
        
        // Add download operations
        for model in models {
            guard case let .notLoaded(url) = model.loadable else {
                continue
            }
            
            let downloadRequest = DownloadData(from: url)
            let sendRequestOperation = SendRequestOperation(connection: connection, request: downloadRequest)
            sendRequestOperation.downloadCompletionBlock = {
                model.loadable = .loaded($0)
            }
            completionOperation.addDependency(sendRequestOperation)
            operationQueue.addOperation(sendRequestOperation)
        }
        
        operationQueue.addOperation(completionOperation)
    }
}

protocol ContainsLoadableData: class {
    var loadable: Loadable<Data>? { get set }
}

extension PaymentNetwork: ContainsLoadableData {
    var loadable: Loadable<Data>? {
        get { logo }
        set { logo = newValue }
    }
}

extension RegisteredAccount: ContainsLoadableData {
    var loadable: Loadable<Data>? {
        get { logo }
        set { logo = newValue }
    }
}
