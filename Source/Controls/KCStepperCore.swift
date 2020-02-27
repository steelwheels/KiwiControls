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
		self.rebounds(origin: KCPoint.zero, size: frm.size)
		#if os(iOS)
			mTextField.text = ""
			mTextField.textAlignment = .center
		#else
			mTextField.stringValue = ""
			mTextField.alignment = .center
		#endif
	}

	open override var fittingSize: KCSize {
		get {
			let labelsize: KCSize
			#if os(OSX)
				labelsize = mTextField.fittingSize
			#else
				labelsize = mTextField.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
			#endif
			let stepsize: KCSize
			#if os(OSX)
				stepsize = mStepper.fittingSize
			#else
				stepsize = mStepper.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
			#endif
			let space = CNPreference.shared.windowPreference.spacing
			return KCUnionSize(sizeA: labelsize, sizeB: stepsize, doVertical: false, spacing: space)
		}
	}

	open override var intrinsicContentSize: KCSize {
		get {
			if hasFixedSize {
				return super.intrinsicContentSize
			} else {
				let fieldsize   = mTextField.intrinsicContentSize
				let steppersize = mStepper.intrinsicContentSize
				let space       = CNPreference.shared.windowPreference.spacing
				return KCUnionSize(sizeA: fieldsize, sizeB: steppersize, doVertical: false, spacing: space)
			}
		}
	}

	open override func resize(_ size: KCSize) {
		let stpsize: KCSize
		#if os(OSX)
			stpsize = mStepper.fittingSize
		#else
			stpsize = mStepper.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		#endif
		let txtwidth: CGFloat
		if size.width > stpsize.width {
			txtwidth = size.width - stpsize.width
		} else {
			log(type: .warning, string: "Too short text", file: #file, line: #line, function: #function)
			txtwidth = 1.0
		}
		let txtsize = KCSize(width: txtwidth, height: stpsize.height)
		mTextField.frame.size  = txtsize
		mTextField.bounds.size = txtsize
		super.resize(size)
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

