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

@IBOutlet weak var mFormattedTextField: KCFormattedTextField!
internal class TestState : CNState {
	internal var isDirty : Bool = false
	
	internal init(isDirty : Bool){
		
	}
}

class ViewController: KCViewController {
    @IBOutlet weak var mLabelField: NSTextField!
	@IBOutlet weak var mTableView: NSTableView!
	@IBOutlet weak var mTableView: NSTableView!
	@IBOutlet weak var mTableView: NSTableView!
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
		state = TestState(isDirty: true)
		state?.updateState()
		state?.updateState()
	}

	internal override func observeState(state : CNState){
		print("observeState")
	}
	
	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

