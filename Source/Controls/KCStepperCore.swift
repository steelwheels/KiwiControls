/**
 * @file	KCStepperCore.swift
 * @brief	Define KCStepperCore class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import KiwiGraphics

public class KCStepperCore: KCView
{
	@IBOutlet weak var	mTextField:	NSTextField!
	@IBOutlet weak var	mStepper:	NSStepper!

	public var numberOfDecimalPlaces: Int	= 2
	public var updateValueCallback: ((_ newvalue: Double) -> Void)? = nil

	public func setup() -> Void {
		mTextField.stringValue = ""
		mTextField.alignment = .center
	}

	private func updateTextField(value: Double){
		let str = String(format: "%.*lf", numberOfDecimalPlaces, value)
		mTextField.stringValue = str
	}

	public var maxValue: Double {
		get { return mStepper.maxValue }
		set(newval) { mStepper.maxValue = newval }
	}

	public var minValue: Double {
		get { return mStepper.minValue }
		set(newval) { mStepper.minValue = newval }
	}

	public var currentValue: Double {
		get { return mStepper.doubleValue }
		set(newval){
			var v = newval
			if v < minValue {
				v = minValue
			} else if v > maxValue {
				v = maxValue
			}
			mStepper.doubleValue = v
			updateTextField(value: v)
		}
	}

	public var increment: Double {
		get { return mStepper.increment }
		set(newval) { mStepper.increment = newval }
	}

	@IBAction func stepperAction(_ sender: NSStepper) {
		let value = sender.doubleValue
		updateTextField(value: value)
		if let callback = updateValueCallback {
			callback(value)
		}
	}
}

