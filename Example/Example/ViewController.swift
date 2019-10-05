import UIKit
import Optile
import Combine

class ViewController: UIViewController {

	let service = PaymentService(paymentSessionURL:
		URL(string: "https://api.sandbox.oscato.com/pci/v1/5d97b993a6cd3d017d5624cclqittnr8omm09sd3e6raoomtfr")!
	)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		service.$session.subscribe(receiveValue: {
			dump($0)
		})
		
		service.loadPaymentSession()
	}


}

