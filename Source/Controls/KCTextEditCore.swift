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

open class KCTextEditCore : KCView, NSTextFieldDelegate
{
	public enum FormatterType {
		case general
		case decimal
	}

	public enum ModeType {
		case label
		case value(FormatterType, Bool) 	/* FormatType: format, Bool: isEditable			*/
		case view(Int)				/* Int: Defautl colmun num				*/
		case edit(Int)				/* Int: Defautl colmun num			*/
	}

	public typealias CallbackFunction = (_ value: CNNativeValue) -> Void

	#if os(OSX)
	@IBOutlet weak var mTextEdit: NSTextField!
	#else
	@IBOutlet weak var mTextEdit: UITextField!
	#endif

	private var 	mMode:			ModeType = .edit(40)

	public var 	callbackFunction:	CallbackFunction? = nil

	public func setup(frame frm: CGRect){
		KCView.setAutolayoutMode(views: [self, mTextEdit])
		#if os(OSX)
		if let cell = mTextEdit.cell {
			cell.wraps		= true
			cell.isScrollable	= false
		}
		#endif

		#if os(OSX)
			mTextEdit.delegate = self
		#else
			mTextEdit.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
		#endif
	}

	public var mode: ModeType {
		get { return mMode }
		set(newmode){
			#if os(OSX)
			set(mode: newmode)
			#endif
			mMode = newmode
		}
	}

	#if os(OSX)
	private func set(mode md: ModeType) {
		switch md {
		case .label:
			mTextEdit.isEditable		= false
			mTextEdit.isBezeled		= false
			mTextEdit.usesSingleLineMode 	= true
			mTextEdit.lineBreakMode		= .byWordWrapping
			mTextEdit.formatter 		= nil
		case .value(let format, let editable):
			mTextEdit.isEditable		= editable
			mTextEdit.isBezeled		= true
			mTextEdit.usesSingleLineMode 	= false
			mTextEdit.lineBreakMode		= .byWordWrapping
			switch format {
			case .general:
				mTextEdit.formatter = nil
			case .decimal:
				let numformatter = NumberFormatter()
				numformatter.numberStyle           = .decimal
				numformatter.maximumFractionDigits = 0
				numformatter.minimumFractionDigits = 0
				mTextEdit.formatter	= numformatter
				mTextEdit.font		= NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
			}
		case .view:
			mTextEdit.isEditable		= false
			mTextEdit.isBezeled		= false
			mTextEdit.usesSingleLineMode 	= false
			mTextEdit.lineBreakMode		= .byWordWrapping
			mTextEdit.formatter 		= nil
			mTextEdit.font			= NSFont.systemFont(ofSize: NSFont.systemFontSize)
		case .edit:
			mTextEdit.isEditable		= true
			mTextEdit.isBezeled		= false
			mTextEdit.usesSingleLineMode 	= false
			mTextEdit.lineBreakMode		= .byWordWrapping
			mTextEdit.formatter 		= nil
			mTextEdit.font			= NSFont.systemFont(ofSize: NSFont.systemFontSize)
		}
	}
	#endif

	open override func setFrameSize(_ newsize: KCSize) {
		super.setFrameSize(newsize)
		#if os(OSX)
			mTextEdit.setFrameSize(newsize)
		#else
			mTextEdit.setFrameSize(size: newsize)
		#endif
	}

	#if os(OSX)
	open override var intrinsicContentSize: KCSize {
		get {
			let curnum = mTextEdit.stringValue.count
			let colnum: Int
			switch mMode {
			case .label, .value:
				colnum = 20
			case .view(let num):
				colnum = num
			case .edit(let num):
				colnum = num
			}
			let newnum   = max(curnum, colnum)

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

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		mTextEdit.invalidateIntrinsicContentSize()
	}

	public override func setExpandabilities(priorities prival: KCViewBase.ExpansionPriorities) {
		mTextEdit.setExpansionPriorities(priorities: prival)
		super.setExpandabilities(priorities: prival)
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

	public var value: CNNativeValue {
		get {
			let result: CNNativeValue
			switch mMode {
			case .edit(_), .label, .view(_):
				result = .stringValue(self.text)
			case .value(let format, _):
				switch format {
				case .decimal:
					if let val = Int(self.text) {
						result = .numberValue(NSNumber(integerLiteral: val))
					} else {
						result = .nullValue
					}
				case .general:
					result = .stringValue(self.text)
				}
			}
			return result
		}
		set(newval) {
			let txt    = newval.toText()
			let str    = txt.toStrings().joined(separator: "\n")
			self.text = str
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
		let val = self.value
		switch val {
		case .nullValue:
			break
		default:
			if let cbfunc = self.callbackFunction {
				cbfunc(val)
			}
		}
	}
}

