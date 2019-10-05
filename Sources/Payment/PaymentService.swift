import Foundation
import Network

@objc public protocol PaymentServiceDelegate {
	func paymentService(_ paymentService: PaymentService, paymentSessionDidFetch: PaymentSession)
	func paymentService(_ paymentService: PaymentService, paymentSessionDidFail: Error)
	
	
}

@objc public class PaymentService: NSObject {
	public var paymentSessionURL: URL
	public weak var delegate: PaymentServiceDelegate?
	
	public init(paymentSessionURL: URL) {
		self.paymentSessionURL = paymentSessionURL
		super.init()
	}
	
	public func loadPaymentSession() {
		let getListResult = GetListResult(url: paymentSessionURL)
		let client = BackendClient()
		client.send(request: getListResult) { [weak self] result in
			guard let weakSelf = self else { return }
			
			switch result {
			case .success(let listResult):
				let paymentSession = PaymentSession(importFrom: listResult)
				weakSelf.delegate?.paymentService(weakSelf, paymentSessionDidFetch: paymentSession)
			case .failure(let error):
				weakSelf.delegate?.paymentService(weakSelf, paymentSessionDidFail: error)
			}
		}
	}
	
	public func loadLogo(for paymentNetwork: PaymentNetwork, completionHandler: @escaping ((Result<Data, Error>) -> Void)) {
		
	}
}

private extension PaymentSession {
	convenience init(importFrom listResult: ListResult) {
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
