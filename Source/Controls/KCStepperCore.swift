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

public class KCStepperCore: KCCoreView
{
	#if os(iOS)
	@IBOutlet weak var mTextField:		UILabel!
	@IBOutlet weak var mStepper:		UIStepper!
	#else
	@IBOutlet weak var mTextField: 		NSTextField!
	@IBOutlet weak var mDecButton: 		NSButton!
	@IBOutlet weak var mIncButton: 		NSButton!
	private var        mCurrentValue:	Double =   0
	private var 	   mMaxValue:		Double = 100
	private var 	   mMinValue:		Double =   0
	#endif

	public var minWidth: Int		= 16
	public var deltaValue: Double		= 1.0
	public var decimalPlaces: Int		= 2
	public var updateValueCallback: ((_ newvalue: Double) -> Void)? = nil

	public func setup(frame frm: CGRect) -> Void {
		super.setup(isSingleView: false, coreView: mTextField)
		#if os(iOS)
			KCView.setAutolayoutMode(views: [self, mTextField, mStepper])
			mTextField.text = ""
			mTextField.textAlignment = .center
		#else
			KCView.setAutolayoutMode(views: [self, mTextField, mDecButton, mIncButton])
			mTextField.stringValue = ""
			mTextField.alignment = .center
		#endif
	}

	private func updateTextField(value: Double){
		let str = String(format: "%.*lf", decimalPlaces, value)
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
				return mMaxValue
			#endif
		}
		set(newval) {
			#if os(iOS)
				self.mStepper.maximumValue = Double(newval)
			#else
				mMaxValue = newval
			#endif
		}
	}

	public var minValue: Double {
		get {
			#if os(iOS)
				return mStepper.minimumValue
			#else
				return mMinValue
			#endif
		}
		set(newval) {
			#if os(iOS)
				self.mStepper.minimumValue = newval
			#else
				mMinValue = newval
			#endif
		}
	}

	public var currentValue: Double {
		get {
			#if os(iOS)
				return mStepper.value
			#else
				return mCurrentValue
			#endif
		}
		set(newval){
			let v = clipValue(value: newval)
			let updated: Bool
			#if os(iOS)
				updated = (self.mStepper.value != v)
			#else
				updated = (mCurrentValue != v)
			#endif
			if updated {
				#if os(iOS)
					self.mStepper.value = v
				#else
					mCurrentValue = v
				#endif
				self.updateTextField(value: v)
				if let callback = updateValueCallback {
					callback(v)
				}
			}
		}
	}

	public var isIncrementable: Bool {
		get {
			#if os(iOS)
				return true
			#else
				return mIncButton.isEnabled
			#endif
		}
		set(newval){
			#if os(OSX)
				mIncButton.isEnabled = newval
			#endif
		}
	}

	public var isDecrementable: Bool {
		get {
			#if os(iOS)
				return true
			#else
				return mDecButton.isEnabled
			#endif
		}
		set(newval){
			#if os(OSX)
				mDecButton.isEnabled = newval
			#endif
		}
	}

	public var isVisible: Bool {
		get {
			#if os(iOS)
				return !(mStepper.isHidden)
			#else
				return !(mTextField.isHidden)
			#endif
		}
		set(newval){
			#if os(iOS)
				mStepper.isHidden	= !newval
			#else
				mIncButton.isHidden	= !newval
				mDecButton.isHidden	= !newval
			#endif
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
	@IBAction func decButtonAction(_ sender: Any) {
		/* Decrement current value */
		let nextval = clipValue(value: mCurrentValue - deltaValue)
		/* Update values */
		if nextval != mCurrentValue {
			updateTextField(value: nextval)
			if let callback = updateValueCallback {
				callback(nextval)
			}
			mCurrentValue = nextval
		}
	}

	@IBAction func incButtonAction(_ sender: Any) {
		/* Increment current value */
		let nextval = clipValue(value: mCurrentValue + deltaValue)
		/* Update values */
		if nextval != mCurrentValue {
			updateTextField(value: nextval)
			if let callback = updateValueCallback {
				callback(nextval)
			}
			mCurrentValue = nextval
		}
	}
	#endif

	open override func setFrameSize(_ newsize: CGSize) {
		super.setFrameSize(newsize)

		let totalwidth   = newsize.width
		let stepersize   = stepperButtonSize()
		var stepperwidth = stepersize.width
		var fieldwidth   = totalwidth - stepperwidth
		if fieldwidth <= 0.0 {
			stepperwidth = totalwidth / 2.0
			fieldwidth   = totalwidth / 2.0
		}
		let fieldsize   = CGSize(width: fieldwidth,   height: newsize.height)
		mTextField.setFrame(size: fieldsize)
	}

	#if os(OSX)
	open override var fittingSize: CGSize {
		get { return CNMinSize(contentsSize(), self.limitSize) }
	}
	#else
	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		return CNMinSize(adjustContentsSize(size: size), self.limitSize)
	}
	#endif

	open override var intrinsicContentSize: CGSize {
		get { return CNMinSize(contentsSize(), self.limitSize) }
	}

	public override func contentsSize() -> CGSize {
		/* Get text field size*/
		#if os(OSX)
		let curnum  = mTextField.stringValue.count
		let newnum  = max(curnum, minWidth)
		let fitsize = mTextField.fittingSize
		let newwidth:  CGFloat
		let fontsize = fontSize(font: mTextField.font)
		newwidth = fontsize.width * CGFloat(newnum)
		let fieldsize   = CGSize(width: newwidth, height: fitsize.height)
		#else
		let fieldsize   = mTextField.intrinsicContentSize
		#endif
		/* Ger stepper size*/
		let steppersize = stepperButtonSize()
		let space  = CNPreference.shared.windowPreference.spacing
		let usize  = CNUnionSize(fieldsize, steppersize, doVertical: false, spacing: space)
		return usize
	}

	public override func adjustContentsSize(size sz: CGSize) -> CGSize {
		let steppersize = stepperButtonSize()
		guard steppersize.width <= sz.width && steppersize.height <= sz.height else {
			CNLog(logLevel: .error, message: "Size overflow", atFunction: #function, inFile: #file)
			return contentsSize()
		}
		let fieldsize = mTextField.intrinsicContentSize
		let newsize   = CGSize(width: sz.width - steppersize.width, height: sz.height)
		if fieldsize.width <= newsize.width && fieldsize.height <= newsize.height {
			return sz
		} else {
			CNLog(logLevel: .error, message: "Size overflow", atFunction: #function, inFile: #file)
			return contentsSize()
		}
	}

	private func stepperButtonSize() -> CGSize {
		#if os(iOS)
			return mStepper.frame.size
		#else
			let dsize = mDecButton.frame.size
			let isize = mIncButton.frame.size
			return CGSize(width: dsize.width + isize.width, height: max(dsize.height, isize.height))
		#endif
	}

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		mTextField.invalidateIntrinsicContentSize()
	}

	private func clipValue(value v: Double) -> Double {
		let result: Double
		let minv = self.minValue
		let maxv = self.maxValue
		if v < minv {
			result = minv
		} else if v > maxv {
			result = maxv
		} else {
			result = v
		}
		return result
	}
}

