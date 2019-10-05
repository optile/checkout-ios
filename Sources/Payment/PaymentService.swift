import Foundation
import Network

public class PaymentService {
	public var paymentSessionURL: URL
	@CurrentValue public var session: Load<PaymentSession> = .inactive
	
	public init(paymentSessionURL: URL) {
		self.paymentSessionURL = paymentSessionURL
		
	}
	
	public func loadPaymentSession() {
		session = .loading
		let getListResult = GetListResult(url: paymentSessionURL)
		let client = BackendClient()
		client.send(request: getListResult) { [weak self] result in
			switch result {
			case .success(let listResult):
				let paymentSession = PaymentSession(importFrom: listResult)
				self?.session = .success(paymentSession)
			case .failure(let error):
				self?.session = .failure(error)
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
	convenience init(importFrom applicableNetwork: ApplicableNetwork) {
		self.init(label: applicableNetwork.label, logoURL: applicableNetwork.links?.logo)
	}
}
