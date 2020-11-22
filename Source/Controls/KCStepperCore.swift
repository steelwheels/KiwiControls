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

	open override var intrinsicContentSize: KCSize {
		get {
			let fieldsize   = mTextField.intrinsicContentSize
			let steppersize = mStepper.intrinsicContentSize
			let space       = CNPreference.shared.windowPreference.spacing
			return KCUnionSize(sizeA: fieldsize, sizeB: steppersize, doVertical: false, spacing: space)
		}
	}

	public override func setExpandability(holizontal holiz: KCViewBase.ExpansionPriority, vertical vert: KCViewBase.ExpansionPriority) {
		mTextField.setExpansionPriority(holizontal: holiz, vertical: vert)
		mStepper.setExpansionPriority(holizontal: .Fixed, vertical: .Fixed)
		super.setExpandability(holizontal: holiz, vertical: vert)
	}

	private func updateTextField(value: Double){
		let str = String(format: "%.*lf", numberOfDecimalPlaces, value)
		CNExecuteInMainThread(doSync: false, execute: {
			[weak self] () -> Void in
			if let myself = self {
				#if os(iOS)
					myself.mTextField.text = str
				#else
					myself.mTextField.stringValue = str
				#endif
			}
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
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					#if os(iOS)
						myself.mStepper.maximumValue = newval
					#else
						myself.mStepper.maxValue = newval
					#endif
				}
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
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					#if os(iOS)
						myself.mStepper.minimumValue = newval
					#else
						myself.mStepper.minValue = newval
					#endif
				}
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
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					#if os(iOS)
						myself.mStepper.value = v
					#else
						myself.mStepper.doubleValue = v
					#endif
					myself.updateTextField(value: v)
				}
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
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					#if os(iOS)
						myself.mStepper.stepValue = newval
					#else
						myself.mStepper.increment = newval
					#endif
				}
			})
		}
	}

	public var isEnabled: Bool {
		get {
			return mStepper.isEnabled
		}
		set(newval){
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					myself.mStepper.isEnabled   = newval
					myself.mTextField.isEnabled = newval
				}
			})
		}
	}

	public var isVisible: Bool {
		get {
			return !(mStepper.isHidden)
		}
		set(newval){
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					myself.mStepper.isHidden   = !newval
					myself.mTextField.isHidden = !newval
					myself.isHidden      = !newval
				}
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
}

