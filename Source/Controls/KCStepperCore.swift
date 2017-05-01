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
	#if os(iOS)
	@IBOutlet weak var	mTextField: UILabel!
	@IBOutlet weak var	mStepper: UIStepper!
	#else
	@IBOutlet weak var	mTextField:	NSTextField!
	@IBOutlet weak var	mStepper:	NSStepper!
	#endif

	public var numberOfDecimalPlaces: Int	= 2
	public var updateValueCallback: ((_ newvalue: Double) -> Void)? = nil

	public func setup() -> Void {
		#if os(iOS)
			mTextField.text = ""
			mTextField.textAlignment = .center
		#else
			mTextField.stringValue = ""
			mTextField.alignment = .center
		#endif
	}

	private func updateTextField(value: Double){
		let str = String(format: "%.*lf", numberOfDecimalPlaces, value)
		#if os(iOS)
			mTextField.text = str
		#else
			mTextField.stringValue = str
		#endif
	}

	public var maxValue: Double {
		get {
			#if os(iOS)
				return mStepper.maximumValue
			#else
				return mStepper.maxValue
			#endif
		}
		set(newval) {
			#if os(iOS)
				mStepper.maximumValue = newval
			#else
				mStepper.maxValue = newval
			#endif
		}
	}

	public var minValue: Double {
		get {
			#if os(iOS)
				return mStepper.minimumValue
			#else
				return mStepper.minValue
			#endif
		}
		set(newval) {
			#if os(iOS)
				mStepper.minimumValue = newval
			#else
				mStepper.minValue = newval
			#endif
		}
	}

	public var currentValue: Double {
		get {
			#if os(iOS)
				return mStepper.value
			#else
				return mStepper.doubleValue
			#endif
		}
		set(newval){
			var v = newval
			if v < minValue {
				v = minValue
			} else if v > maxValue {
				v = maxValue
			}
			#if os(iOS)
				mStepper.value = v
			#else
				mStepper.doubleValue = v
			#endif
			updateTextField(value: v)
		}
	}

	public var increment: Double {
		get {
			#if os(iOS)
				return mStepper.stepValue
			#else
				return mStepper.increment
			#endif
		}
		set(newval) {
			#if os(iOS)
				mStepper.stepValue = newval
			#else
				mStepper.increment = newval
			#endif
		}
	}

	public var isEnabled: Bool {
		get {
			return mStepper.isEnabled
		}
		set(newval){
			mStepper.isEnabled   = newval
			mTextField.isEnabled = newval
		}
	}

	public var isVisible: Bool {
		get {
			return !(mStepper.isHidden)
		}
		set(newval){
			mStepper.isHidden   = !newval
			mTextField.isHidden = !newval
			super.isHidden      = !newval
		}
	}

	#if os(iOS)
	@IBAction func stepperAction(_ sender: UIStepper) {
		let value = sender.value
		updateTextField(value: value)
		if let callback = updateValueCallback {
			callback(value)
		}
	}
	#else
	@IBAction func stepperAction(_ sender: NSStepper) {
		let value = sender.doubleValue
		updateTextField(value: value)
		if let callback = updateValueCallback {
			callback(value)
		}
	}
	#endif

	open override func printDebugInfo(indent idt: Int){
		super.printDebugInfo(indent: idt)
		if let v = mTextField {
			v.printDebugInfo(indent: idt+1)
		}
		if let v = mStepper {
			v.printDebugInfo(indent: idt+1)
		}
	}
}

