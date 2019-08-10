/**
 * @file	ViewController.swift
 * @brief	View controller for UTControl
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Cocoa
import CoconutData
import KiwiControls

class UTViewController: NSViewController
{
	@IBOutlet weak var mButton: KCButton!
	@IBOutlet weak var mStepper: KCStepper!
	@IBOutlet weak var mCheckBox: KCCheckBox!
	@IBOutlet weak var mTextField: KCTextField!
	@IBOutlet weak var mIconView: KCIconView!
	@IBOutlet weak var mConsoleView: KCConsoleView!

	private var		mState:  UTState? = nil

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		let state = UTState()
		let buttonback = KCColorPreference.BackgroundColors(highlight: NSColor.lightGray, normal: NSColor.black)
		mButton.setColors(colors: KCColorPreference.ButtonColors(title: NSColor.cyan, background: buttonback))
		mButton.buttonPressedCallback = {
			() -> Void in
			Swift.print("buttonPressedCallback")
		}

		mStepper.maxValue     = 5.0
		mStepper.minValue     = 2.0
		mStepper.increment    = 1.0
		mStepper.numberOfDecimalPlaces = 0
		mStepper.currentValue = 2.0
		mStepper.updateValueCallback = {
			(value: Double) -> Void in
			Swift.print("updateValueCallback = \(value)")
		}

		mCheckBox.title = "Check Box"
		mCheckBox.checkUpdatedCallback = {
			(value: Bool) -> Void in
			Swift.print("update check box value: \(value)")
		}

		let textcolor = KCColorPreference.TextColors(foreground: KCColorTable.gold4, background: KCColorTable.gold)
		let table = KCFontTable.sharedFontTable
		mTextField.font = table.font(withStyle: .Title)
		mTextField.text = "Hello, World !!"
		mTextField.alignment = .center
		mTextField.setColors(colors: textcolor)

		mIconView.label = "Icon Label"
		mIconView.imageDrawer = {
			(context: CGContext, bounds: CGRect) -> Void in
			Swift.print("Icon view")
			context.fill(bounds)
		}

		mConsoleView.appendText(normal: "Hello, world!!\n")
		mConsoleView.appendText(normal: "Good, evening!!\n")

		mState = state
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

