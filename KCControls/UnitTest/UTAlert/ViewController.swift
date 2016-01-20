//
//  ViewController.swift
//  UTAlert
//
//  Created by Tomoo Hamada on 2015/11/08.
//  Copyright © 2015年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import Canary
import KCControls

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		let error = NSError.serializeError("Error message")
		KCAlert.runModal(error)
		
		switch KCAlert.recommendSaveModal("The \"file\""){
		case .CancelButtonPressed:
			print("cancel button pressed")
		case .SaveButtonPressed:
			print("save button pressed")
		case .DontSaveButtonPressed:
			print("don't save button pressed")
		}
		
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

