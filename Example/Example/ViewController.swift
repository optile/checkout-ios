import UIKit
import Optile

class ViewController: UIViewController {

	let listResultURL = URL(string: "https://api.sandbox.oscato.com/pci/v1/5d9b33f7148b51017a98d4fflo5ud882vp731kf5m7tiunspi8")!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
			
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		let vc = PaymentMethodsViewContoller(listResultURL: listResultURL)
		present(vc, animated: true, completion: nil)
	}


}

