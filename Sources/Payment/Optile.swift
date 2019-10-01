import Foundation
import API

@objc public class Optile: NSObject {
	// POST https://api.sandbox.oscato.com/api/lists
	// GET https://api.sandbox.oscato.com/pci/v1/5d8e0a272d221101917d1650lucqs520r3a38b1r4uljq4qh2i?view=jsonForms,-htmlForms

	let client: APIClient
	
	override public init() {
		let endpoint = URL(string: "https://api.sandbox.oscato.com")!
		let requestSender = URLSessionRequestSender(endpoint: endpoint)
		self.client = APIClient(requestSender: requestSender)
		super.init()
	}
	
	public func run(longID: String) {
		let request = GetPaymentSession(longId: longID)
		client.send(request: request) { result in
			switch result {
			case .failure(let error):
				debugPrint(error)
			case .success(let response):
				dump(response)
			}
		}
	}
	
	
	func test() {
//		let request = 
	}
}
