import Foundation
import Network

public class PaymentService {
	public var paymentSessionURL: URL
	public var session = ObservableObject<Loadable<PaymentSession>?>(nil)
	
	public init(paymentSessionURL: URL) {
		self.paymentSessionURL = paymentSessionURL
	}
	
	public func loadPaymentSession(completionHandler: @escaping ((Result<PaymentSession, Error>) -> Void)) {
		let getListResult = GetListResult(url: paymentSessionURL)
		let client = BackendClient()
		client.send(request: getListResult) { result in
			switch result {
			case .success(let listResult):
				let session = PaymentSession(importFrom: listResult)
				completionHandler(.success(session))
			case .failure(let error):
				completionHandler(.failure(error))
			}
		}
	}
	
	public func loadLogo(for paymentNetwork: PaymentNetwork, completionHandler: @escaping ((Result<Data, Error>) -> Void)) {
		
	}
}

private extension PaymentSession {
	init(importFrom listResult: ListResult) {
		let networks = listResult.networks.applicable.map {
			PaymentNetwork(importFrom: $0)
		}
		
		self.init(networks: networks)
	}
}

private extension PaymentNetwork {
	init(importFrom applicableNetwork: ApplicableNetwork) {
		self.label = applicableNetwork.label
		self.logoURL = applicableNetwork.links?.logo
	}
}
