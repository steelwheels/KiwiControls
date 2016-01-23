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

class ViewController: KCViewController {
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
		//print("set 1st state")
		//state = KCDocumentState(isDirty: true)
		print("add observer")
		addStateObserver(self)
		print("set 2nd state")
		state = KCDocumentState(isDirty: false)
	}

	internal override func observeState(state : KCState){
		var message : String
		if let s = state as? KCDocumentState {
			if s.isDirty {
				message = "dirty"
			} else {
				message = "clean"
			}
		} else {
			message = "unknown"
		}
		print("observeState : \(message)")
	}
	
	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

