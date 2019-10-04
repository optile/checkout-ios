import Foundation
import Network

public class PaymentService {
	public func loadPaymentSession(from paymentSession: URL, completionHandler: @escaping ((Result<PaymentSession, Error>) -> Void)) {
		let getListResult = GetListResult(url: paymentSession)
		// FIXME: Change to real URL, when I know if we need it anywhere
		let backendURL = URL(string: "http://example.com")!
		let client = BackendClient(endpoint: backendURL)
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
		#if canImport(UIKit)
		self.logo = nil
		#endif
	}
}
