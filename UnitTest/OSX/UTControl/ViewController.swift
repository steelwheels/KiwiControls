//
//  ViewController.swift
//  UTControl
//
//  Created by Tomoo Hamada on 2016/12/23.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import Canary
import KiwiControls
import KiwiGraphics

class ViewController: NSViewController
{
	@IBOutlet weak var mButton: KCButton!
	@IBOutlet weak var mStepper: KCStepper!
	@IBOutlet weak var mCheckBox: KCCheckBox!
	@IBOutlet weak var mTextField: KCTextField!
	
	private var		mState:  UTState? = nil

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		let state = UTState()
		mButton.state	= state
		let buttonback = KGColorPreference.BackgroundColors(highlight: NSColor.lightGray, normal: NSColor.black)
		mButton.setColors(colors: KGColorPreference.ButtonColors(title: NSColor.cyan, background: buttonback))
		mButton.decideEnableCallback = {
			(_: CNState) -> Bool? in
			return nil
		}
		mButton.decideVisibleCallback = {
			(_: CNState) -> Bool? in
			return nil
		}
		mButton.buttonPressedCallback = {
			() -> Void in
			Swift.print("buttonPressedCallback")
		}

		mStepper.state	      = state
		mStepper.maxValue     = 5.0
		mStepper.minValue     = 2.0
		mStepper.increment    = 1.0
		mStepper.numberOfDecimalPlaces = 0
		mStepper.currentValue = 2.0
		mStepper.decideEnableCallback = {
			(_: CNState) -> Bool? in
			return nil
		}
		mStepper.decideVisibleCallback = {
			(_: CNState) -> Bool? in
			return nil
		}
		mStepper.updateValueCallback = {
			(value: Double) -> Void in
			Swift.print("updateValueCallback = \(value)")
		}

		mCheckBox.title = "Check Box"
		mCheckBox.decideEnableCallback = {
			(_: CNState) -> Bool? in
			return nil
		}
		mCheckBox.decideVisibleCallback = {
			(_: CNState) -> Bool? in
			return nil
		}
		mCheckBox.checkUpdatedCallback = {
			(value: Bool) -> Void in
			Swift.print("update check box value: \(value)")
		}

		mTextField.text = "Hello, World !!"
		
		mState = state
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

