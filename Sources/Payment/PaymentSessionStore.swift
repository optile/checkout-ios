import Foundation
import Network

public class PaymentSessionStore {
	public var didChange: ((PaymentSessionStore) -> Void)?
	private(set) public var state: LoadableState<PaymentSession> = .inactive {
		didSet {
			didChange?(self)
		}
	}
	
	private let service = PaymentService()
	
	public func load(from listResultURL: URL) {
		state = .loading
		service.loadPaymentSession(from: listResultURL) { [weak self] result in
			self?.state = .fetched(result)
		}
	}
}
