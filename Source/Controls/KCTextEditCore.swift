/**
 * @file	KCTextEditCore.swift
 * @brief	Define KCTextEditCore class
 * @par Copyright
 *   Copyright (C) 2018-2021 Steel Wheels Project
 */

#if os(OSX)
import Cocoa
#else
import UIKit
#endif
import CoconutData

#if os(iOS)
public protocol NSTextFieldDelegate {

}
#endif

open class KCTextEditCore : KCCoreView, NSTextFieldDelegate
{
	public typealias CallbackFunction = (_ str: String) -> Void

	#if os(OSX)
	@IBOutlet weak var mTextEdit: NSTextField!
	#else
	@IBOutlet weak var mTextEdit: UITextField!
	#endif

	private var 	mIsBold:		Bool 	= false
	private var 	mDecimalPlaces:		Int	= 0
	private var 	mMinWidth:		Int     = 40

	private var	mCurrentValue:		CNValue = .nullValue

	public var 	callbackFunction:	CallbackFunction? = nil

	public func setup(frame frm: CGRect){
		super.setup(isSingleView: true, coreView: mTextEdit)
		KCView.setAutolayoutMode(views: [self, mTextEdit])
		#if os(OSX)
		if let cell = mTextEdit.cell {
			cell.wraps		= true
			cell.isScrollable	= false
		}
		#endif

		#if os(OSX)
			mTextEdit.delegate = self
			mTextEdit.lineBreakMode	= .byWordWrapping
		#else
			mTextEdit.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
		#endif

		/* Initialize */
		self.isEnabled	= true
		self.isEditable	= false
		setFormat(isNumber: false, isBold: mIsBold, isEditable: self.isEditable, decimalPlaces: mDecimalPlaces)
		mCurrentValue	= .stringValue("")
	}

	public var isBold: Bool {
		get         { return mIsBold }
		set(newval) { mIsBold = newval }
	}

	public var decimalPlaces: Int {
		get { return mDecimalPlaces }
		set(newval){ mDecimalPlaces = newval }
	}

	public var isEditable: Bool {
		get {
			#if os(OSX)
				return mTextEdit.isEditable
			#else
				return false
			#endif
		}
		set(newval) {
			#if os(OSX)
				mTextEdit.isEditable = newval
			#endif
		}
	}

	public var isEnabled: Bool {
		get	   { return mTextEdit.isEnabled		}
		set(newval){ mTextEdit.isEnabled = newval	}
	}

	#if os(OSX)
	public var preferredTextFieldWidth: CGFloat {
		get           { return mTextEdit.preferredMaxLayoutWidth }
		set(newwidth) { mTextEdit.preferredMaxLayoutWidth = newwidth }
	}
	#endif

	public var font: CNFont? {
		get {
			return mTextEdit.font
		}
		set(font){
			mTextEdit.font = font
		}
	}

	public var alignment: NSTextAlignment {
		get {
			#if os(OSX)
				return mTextEdit.alignment
			#else
				return mTextEdit.textAlignment
			#endif
		}
		set(align){
			#if os(OSX)
				mTextEdit.alignment = align
			#else
				mTextEdit.textAlignment = align
			#endif
		}
	}

	public var text: String {
		get {
			#if os(OSX)
			return mTextEdit.stringValue
			#else
			if let t = mTextEdit.text {
				return t
			} else {
				return ""
			}
			#endif
		}
		set(newval) {
			setFormat(isNumber: false, isBold: mIsBold, isEditable: self.isEditable, decimalPlaces: mDecimalPlaces)
			setString(string: newval)
			mCurrentValue = .stringValue(newval)
		}
	}

	public var number: NSNumber {
		get {
			if let val = Double(self.text) {
				return NSNumber(value: val)
			} else {
				CNLog(logLevel: .error, message: "Failed to decode current number", atFunction: #function, inFile: #file)
				return NSNumber(booleanLiteral: false)
			}
		}
		set(newval){
			setFormat(isNumber: true, isBold: mIsBold, isEditable: self.isEditable, decimalPlaces: mDecimalPlaces)
			setNumber(number: newval, decimalPlaces: self.decimalPlaces)
			mCurrentValue = .numberValue(newval)
		}
	}

	#if os(OSX)
	open override var intrinsicContentSize: CGSize {
		get {
			let curnum  = mTextEdit.stringValue.count
			let newnum  = max(curnum, mMinWidth)
			let fitsize = mTextEdit.fittingSize

			let newwidth:  CGFloat
			let fontsize = self.fontSize(font: mTextEdit.font)
			newwidth = fontsize.width * CGFloat(newnum)

			mTextEdit.preferredMaxLayoutWidth = newwidth
			return CGSize(width: newwidth, height: fitsize.height)
		}
	}
	#else
	open override var intrinsicContentSize: CGSize {
		get { return mTextEdit.intrinsicContentSize }
	}
	#endif

	#if os(OSX)
	public override var acceptsFirstResponder: Bool { get {
		return mTextEdit.acceptsFirstResponder
	}}
	#endif

	public override func becomeFirstResponder() -> Bool {
		return mTextEdit.becomeFirstResponder()
	}

	private func setString(string str: String) {
		#if os(OSX)
			if self.isEditable {
				mTextEdit.placeholderString = str
			} else {
				mTextEdit.stringValue = str
			}
		#else
			mTextEdit.text        = str
		#endif
		mTextEdit.invalidateIntrinsicContentSize()
	}

	private func setNumber(number num: NSNumber, decimalPlaces dplaces: Int?) {
		let newstr: String
		if let dp = dplaces {
			if 0 <= dp {
				newstr = String(format: "%.*lf", dp, num.doubleValue)
			} else {
				newstr = "\(num.intValue)"
			}
		} else {
			newstr = "\(num.intValue)"
		}
		setString(string: newstr)
	}

	private func setFormat(isNumber num: Bool, isBold bld: Bool, isEditable edt: Bool, decimalPlaces dplace: Int) {
		/* Set font */
		let font: CNFont
		if num {
			font = CNFont.monospacedSystemFont(ofSize: CNFont.systemFontSize, weight: .regular)
		} else if bld {
			font = CNFont.boldSystemFont(ofSize: CNFont.systemFontSize)
		} else {
			font = CNFont.systemFont(ofSize: CNFont.systemFontSize)
		}
		mTextEdit.font = font

		/* Set attributes */
		#if os(OSX)
		mTextEdit.isEditable		= edt
		mTextEdit.usesSingleLineMode 	= true
		if num {
			/* For number */
			let numform = NumberFormatter()
			numform.numberStyle		= .decimal
			numform.maximumFractionDigits	= dplace
			numform.minimumFractionDigits	= dplace
			mTextEdit.formatter		= numform
		} else {
			/* for text */
			mTextEdit.formatter		= nil
		}
		#endif

		/* Set bezel */
		#if os(OSX)
			mTextEdit.isBezeled   = edt
		#else
			mTextEdit.borderStyle = edt ? .bezel : .none
		#endif
	}

	#if os(OSX)
	public func controlTextDidEndEditing(_ obj: Notification) {
		notifyTextDidEndEditing()
	}
	#else
	@objc public func textFieldDidChange(_ textEdit: KCTextEdit) {
		notifyTextDidEndEditing()
	}
	#endif

	public func notifyTextDidEndEditing() {
		NSLog("nTDEE: \(self.text)")
		if let cbfunc = self.callbackFunction {
			cbfunc(self.text)
		}
	}
}

