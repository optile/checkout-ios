//
//  ViewController.swift
//  Example
//
//  Created by Vasily Ulianov on 29.09.2019.
//  Copyright © 2019 optile GmbH. All rights reserved.
//

import UIKit
import Optile

class ViewController: UIViewController {

	let optile = Optile()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		optile.run(longID: "5d9119072d221101917d24a5ln8mvu7jrp9upj5vebnvh8j0ek")
	}


}

