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
		KCView.setAutolayoutMode(views: [self, mTextField, mStepper])
		#if os(iOS)
			mTextField.text = ""
			mTextField.textAlignment = .center
		#else
			mTextField.stringValue = ""
			mTextField.alignment = .center
		#endif
	}

	open override func setFrameSize(_ newsize: KCSize) {
		super.setFrameSize(newsize)

		let totalwidth   = newsize.width
		var stepperwidth = mStepper.frame.size.width
		var fieldwidth   = totalwidth - stepperwidth
		if fieldwidth <= 0.0 {
			stepperwidth = totalwidth / 2.0
			fieldwidth   = totalwidth / 2.0
		}
		let steppersize = KCSize(width: stepperwidth, height: newsize.height)
		let fieldsize   = KCSize(width: fieldwidth,   height: newsize.height)
		#if os(OSX)
			mStepper.setFrameSize(steppersize)
			mTextField.setFrameSize(fieldsize)
		#else
			mStepper.setFrameSize(size: steppersize)
			mTextField.setFrameSize(size: fieldsize)
		#endif
	}

	open override var intrinsicContentSize: KCSize {
		get {
			let fieldsize   = mTextField.intrinsicContentSize
			let steppersize = mStepper.intrinsicContentSize
			let space       = CNPreference.shared.windowPreference.spacing
			return KCUnionSize(sizeA: fieldsize, sizeB: steppersize, doVertical: false, spacing: space)
		}
	}

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		mTextField.invalidateIntrinsicContentSize()
		mStepper.invalidateIntrinsicContentSize()
	}

	public override func setExpandabilities(priorities prival: KCViewBase.ExpansionPriorities) {
		mTextField.setExpansionPriorities(priorities: prival)
		mStepper.setExpansionPriorities(priorities: prival)
		super.setExpandabilities(priorities: prival)
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
				self.mStepper.maximumValue = newval
			#else
				self.mStepper.maxValue = newval
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
				self.mStepper.minimumValue = newval
			#else
				self.mStepper.minValue = newval
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
				self.mStepper.value = v
			#else
				self.mStepper.doubleValue = v
			#endif
			self.updateTextField(value: v)
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
			mStepper.isHidden	= !newval
			mTextField.isHidden	= !newval
			self.isHidden		= !newval
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
}

