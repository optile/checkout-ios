import UIKit
import Optile

class ViewController: UIViewController {

	let service = PaymentSessionStore(paymentSessionURL:
		URL(string: "https://api.sandbox.oscato.com/pci/v1/5d98ac15148b51017a98b8d0lpe6o72ae942ejc28pp22vt4vg")!
	)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		// Print to console for testing reasons
		service.$session.subscribe(receiveValue: {
			dump($0)
		})
		
		service.loadPaymentSession()
	}


}

