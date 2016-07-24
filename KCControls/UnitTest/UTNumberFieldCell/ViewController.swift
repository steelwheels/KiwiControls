//
//  ViewController.swift
//  UTNumberFieldCell
//
//  Created by Tomoo Hamada on 2016/07/24.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import Canary
import KCControls

class ViewController: KCViewController
{	
	@IBOutlet weak var mFormattedTextField:	KCFormattedTextField!
	@IBOutlet weak var mLabelField:		NSTextField!
	@IBOutlet weak var mButton:		NSButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		self.state = UTState()
		mFormattedTextField.textDidChangeCallback = { (text: String) -> Void in
			let hasvalid = self.mFormattedTextField.hasValidValue
			Swift.print("textDidChange -> \(hasvalid)")
			if let s = self.state as? UTState {
				s.setValid(hasvalid)
			} else {
				fatalError("Invalid state")
			}
		}
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	internal override func observeState(state : CNState){
		if let s = state as? UTState {
			switch s.stateId {
			case .InvalidValueState:
				mButton.enabled = false
				break
			case .ValidValueState:
				mButton.enabled = true
				mLabelField.stringValue = mFormattedTextField.stringValue
				break
			}
		} else {
			fatalError("Invalid state object")
		}
	}
}

