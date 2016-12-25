//
//  ViewController.swift
//  UTControl
//
//  Created by Tomoo Hamada on 2016/12/23.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import UIKit
import KiwiControls

class ViewController: UIViewController {

	@IBOutlet weak var mButton: KCButton!
	@IBOutlet weak var mStepper: KCStepper!

	private var mState: UTState? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let state = UTState()
		mButton.controllerState = state
		mState = state

		mStepper.maxValue		= 5.0
		mStepper.minValue		= 2.0
		mStepper.increment		= 1.0
		mStepper.numberOfDecimalPlaces	= 0
		mStepper.currentValue		= 2.0
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func buttonPressed(_ sender: KCButton) {
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

