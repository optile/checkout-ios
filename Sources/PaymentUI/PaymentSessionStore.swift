import UIKit
import Payment

struct PaymentNetwork {
	public let label: String
	public let logo: LoadableState<UIImage>?
}

class PaymentSessionStore {
	var didChangeHandler: ((Loadable<[PaymentNetwork]>) -> Void)?
	var networks: Loadable<[PaymentNetwork]>?
	
	init(paymentSessionURL: URL) {
		service = .init(paymentSessionURL: paymentSessionURL)
	}
	
	func load() {
		service.loadPaymentSession() { [weak self] result in
			self?.networks =
		}
	}
	
	func loadImage(for paymentNetwork: PaymentNetwork) {
		session.didChange { (<#Result<PaymentSession, Error>?#>) in
			<#code#>
		}
	}
	
	
//	private var didChangeHandler: ((PaymentSessionProvider) -> Void)?
//	private(set) public var state: LoadableState<PaymentSession>? {
//		didSet {
//			didChangeHandler?(self)
//		}
//	}
//
//	private let service = PaymentService()
//
//	public func load(from listResultURL: URL) {
//		service.loadPaymentSession(from: listResultURL) { [weak self] result in
//			self?.state = .fetched(result)
//		}
//	}
//
//	public func didChange(handler: @escaping ((PaymentSessionProvider) -> Void)) {
//		self.didChangeHandler = handler
//	}
}



