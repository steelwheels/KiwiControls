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
	public enum Format {
		case text
		case label
		case number
	}

	public typealias CallbackFunction = (_ str: String) -> Void

	#if os(OSX)
	@IBOutlet weak var mTextEdit: NSTextField!
	#else
	@IBOutlet weak var mTextEdit: UITextField!
	#endif

	private var 	mFormat:		Format = .text
	private var 	mMinWidth:		Int    = 40
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

		isBezeled = false
		format    = .text
	}

	public var format: Format {
		get		{ return mFormat }
		set(newform)	{
			mFormat = newform
			#if os(OSX)
			switch mFormat {
			case .text:
				mTextEdit.font			= NSFont.systemFont(ofSize: NSFont.systemFontSize)
				mTextEdit.usesSingleLineMode 	= false
				mTextEdit.formatter		= nil
			case .label:
				mTextEdit.font			= NSFont.boldSystemFont(ofSize: NSFont.systemFontSize)
				mTextEdit.usesSingleLineMode 	= true
				mTextEdit.formatter		= nil
				self.isEditable			= false
			case .number:
				mTextEdit.font			= NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
				mTextEdit.usesSingleLineMode 	= true
				let numform = NumberFormatter()
				numform.numberStyle		= .decimal
				numform.maximumFractionDigits	= 0
				numform.minimumFractionDigits	= 0
				mTextEdit.formatter		= numform
			}
			#endif
		}
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

	#if os(OSX)
	open override var intrinsicContentSize: KCSize {
		get {
			let curnum  = mTextEdit.stringValue.count
			let newnum  = max(curnum, mMinWidth)
			let fitsize = mTextEdit.fittingSize

			let newwidth:  CGFloat
			if let fontsize = self.fontSize() {
				newwidth = fontsize.width * CGFloat(newnum)
			} else {
				newwidth = fitsize.width
			}

			mTextEdit.preferredMaxLayoutWidth = newwidth
			return KCSize(width: newwidth, height: fitsize.height)
		}
	}
	#else
	open override var intrinsicContentSize: KCSize {
		get { return mTextEdit.intrinsicContentSize }
	}
	#endif

	private func fontSize() -> KCSize? {
		if let font = mTextEdit.font {
			let attr = [NSAttributedString.Key.font: font]
			let str: String = " "
			return str.size(withAttributes: attr)
		} else {
			return nil
		}
	}

	#if os(OSX)
	public override var acceptsFirstResponder: Bool { get {
		return mTextEdit.acceptsFirstResponder
	}}
	#endif

	public override func becomeFirstResponder() -> Bool {
		return mTextEdit.becomeFirstResponder()
	}

	public var isEnabled: Bool {
		get	   { return mTextEdit.isEnabled		}
		set(newval){ mTextEdit.isEnabled = newval	}
	}

	public var isBezeled: Bool {
		get {
			#if os(OSX)
			return mTextEdit.isBezeled
			#else
			let result: Bool
			switch mTextEdit.borderStyle {
			case .bezel:	result = true
			default:	result = false
			}
			return result
			#endif
		}
		set(newval) {
			#if os(OSX)
			mTextEdit.isBezeled = newval
			#else
			mTextEdit.borderStyle = .bezel
			#endif
		}
	}

	#if os(OSX)
	public var preferredTextFieldWidth: CGFloat {
		get           { return mTextEdit.preferredMaxLayoutWidth }
		set(newwidth) { mTextEdit.preferredMaxLayoutWidth = newwidth }
	}
	#endif

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
			#if os(OSX)
				mTextEdit.stringValue = newval
			#else
				mTextEdit.text = newval
			#endif
			mTextEdit.invalidateIntrinsicContentSize()
		}
	}

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
		if let cbfunc = self.callbackFunction {
			cbfunc(self.text)
		}
	}
}

