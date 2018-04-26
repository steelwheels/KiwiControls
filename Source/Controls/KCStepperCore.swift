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
import CoconutData

public class KCStepperCore: KCView
{
	#if os(iOS)
	@IBOutlet weak var	mTextField:	UILabel!
	@IBOutlet weak var	mStepper:	UIStepper!
	#else
	@IBOutlet weak var	mTextField:	NSTextField!
	@IBOutlet weak var	mStepper:	NSStepper!
	#endif

	public var numberOfDecimalPlaces: Int	= 2
	public var updateValueCallback: ((_ newvalue: Double) -> Void)? = nil

	public func setup(frame frm: CGRect) -> Void {
		let bounds  = CGRect(origin: CGPoint.zero, size: frm.size)
		self.frame  = bounds
		self.bounds = bounds
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
		CNExecuteInMainThread(doSync: false, execute: { () -> Void in
			#if os(iOS)
				self.mTextField.text = str
			#else
				self.mTextField.stringValue = str
			#endif
		})
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
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				#if os(iOS)
					self.mStepper.maximumValue = newval
				#else
					self.mStepper.maxValue = newval
				#endif
			})
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
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				#if os(iOS)
					self.mStepper.minimumValue = newval
				#else
					self.mStepper.minValue = newval
				#endif
			})
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
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				#if os(iOS)
					self.mStepper.value = v
				#else
					self.mStepper.doubleValue = v
				#endif
				self.updateTextField(value: v)
			})
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
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				#if os(iOS)
					self.mStepper.stepValue = newval
				#else
					self.mStepper.increment = newval
				#endif
			})
		}
	}

	public var isEnabled: Bool {
		get {
			return mStepper.isEnabled
		}
		set(newval){
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				self.mStepper.isEnabled   = newval
				self.mTextField.isEnabled = newval
			})
		}
	}

	public var isVisible: Bool {
		get {
			return !(mStepper.isHidden)
		}
		set(newval){
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				self.mStepper.isHidden   = !newval
				self.mTextField.isHidden = !newval
				super.isHidden      = !newval
			})
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

	open override var intrinsicContentSize: KCSize
	{
		let fieldsize   = mTextField.intrinsicContentSize
		let steppersize = mStepper.intrinsicContentSize
		return KCView.unionHolizontalIntrinsicSizes(left: fieldsize, right: steppersize)
	}

	open override func printDebugInfo(indent idt: Int){
		super.printDebugInfo(indent: idt)
		if let v = mTextField {
			KCPrintDebugInfo(view: v, indent: idt+1)
		}
		if let v = mStepper {
			KCPrintDebugInfo(view: v, indent: idt+1)
		}
	}
}

