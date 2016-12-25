//
//  ViewController.swift
//  UTControl
//
//  Created by Tomoo Hamada on 2016/12/23.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import KiwiControls

class ViewController: NSViewController
{
	@IBOutlet weak var	mButton: UTButton!
	@IBOutlet weak var	mStepper: KCStepper!
	private var		mState:  UTState? = nil

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		let state = UTState()
		mButton.controllerState = state
		mState = state

		mStepper.maxValue     = 5.0
		mStepper.minValue     = 2.0
		mStepper.increment    = 1.0
		mStepper.currentValue = 2.0
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	@IBAction func buttonPressed(_ sender: UTButton) {
		Swift.print("buttonPressed")
		if let state = mState {
			switch state.progress {
			case .Init:	state.progress = .Step1
			case .Step1:	state.progress = .Step2
			case .Step2:	state.progress = .Init
			}
		}
	}
}

