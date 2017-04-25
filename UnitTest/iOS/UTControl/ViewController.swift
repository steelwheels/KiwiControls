/**
 * @file	ViewController.swift
 * @brief	Define ViewController class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import UIKit
import KiwiControls

class ViewController: UIViewController
{

	@IBOutlet weak var mTextField: KCTextField!
	@IBOutlet weak var mButton: KCButton!
	@IBOutlet weak var mStepper: KCStepper!
	@IBOutlet weak var mCheckBox: KCCheckBox!
	@IBOutlet weak var mIconView: KCIconView!

	private var mState: UTState? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let state     = UTState()
		let fonttable = KGFontTable.sharedFontTable

		let textcolor = KGColorPreference.TextColors(foreground: KGColorTable.black, background: KGColorTable.gold)
		mTextField.text = "KCTextField"
		mTextField.font = fonttable.font(withStyle: .Title)
		mTextField.alignment = .left
		mTextField.setColors(colors: textcolor)
		
		mButton.state = state
		mButton.isEnabled = true
		mButton.isVisible = true
		mButton.buttonPressedCallback = {
			
			() -> Void in
			Swift.print("buttonPressedCallback")
		}
		let background = KGColorPreference.BackgroundColors(highlight: UIColor.lightGray, normal: UIColor.darkGray)
		mButton.setColors(colors: KGColorPreference.ButtonColors.init(title: UIColor.cyan, background: background))

		mStepper.maxValue		= 5.0
		mStepper.minValue		= 2.0
		mStepper.increment		= 1.0
		mStepper.numberOfDecimalPlaces	= 0
		mStepper.currentValue		= 2.0
		mStepper.isEnabled		= true
		mStepper.isVisible		= true
		mStepper.updateValueCallback = {
			(value: Double) -> Void in
			Swift.print("updateValueCallback = \(value)")
		}

		mCheckBox.title = "Check Box"
		mCheckBox.isEnabled = true
		mCheckBox.isVisible = true
		mCheckBox.checkUpdatedCallback = {
			(value: Bool) -> Void in
			Swift.print("update check box value: \(value)")
		}

		mIconView.label = "The Icon View"
		mIconView.imageDrawer = {
			(context: CGContext, bounds: CGRect) -> Void in
			Swift.print("Draw Icon")
			let hexagon = KGHexagon(bounds: bounds, lineWidth: 2.0)
			context.draw(hexagon: hexagon, withGradient: nil)
		}

		mIconView.label = "The Icon View"
		mIconView.imageDrawer = {
			(context: CGContext, bounds: CGRect) -> Void in
			Swift.print("Draw Icon in \(bounds.description)")
			let hexagon = KGHexagon(bounds: bounds, lineWidth: 2.0)
			Swift.print(" -> hexagon \(hexagon.description)")
			context.draw(hexagon: hexagon, withGradient: nil)
			//context.fillEllipse(in: bounds)
		}
		
		mState = state
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

