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
	@IBOutlet weak var mTextField:		NSTextField!
	@IBOutlet weak var mTableView: NSTableView!
	@IBOutlet weak var mLabelField:		NSTextField!
	@IBOutlet weak var mButton:		NSButton!
	
	var mIntegerFieldDelegate: KCIntegerFieldDelegate? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		self.state = UTState()
		
		let fdelegate = KCIntegerFieldDelegate()
		fdelegate.valueDidChangeCallback = { (value:Int, tag: Int) -> Void in
			if let s = self.state as? UTState {
				s.setValid(true)
			} else {
				fatalError("Invalid state object")
			}
		}
		mIntegerFieldDelegate   = fdelegate
		mTextField.delegate = fdelegate
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
				mLabelField.stringValue = mTextField.stringValue
				break
			}
		} else {
			fatalError("Invalid state object")
		}
	}
}

