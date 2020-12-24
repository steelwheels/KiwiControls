/**
 * @file	KCTextEditCore.swift
 * @brief	Define KCTextEditCore class
 * @par Copyright
 *   Copyright (C) 2018-2020 Steel Wheels Project
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
				mTextEdit.formatter = numformatter
			}
		case .view:
			mTextEdit.isEditable		= false
			mTextEdit.isBezeled		= false
			mTextEdit.usesSingleLineMode 	= false
			mTextEdit.lineBreakMode		= .byWordWrapping
			mTextEdit.formatter 		= nil
		case .edit:
			mTextEdit.isEditable		= true
			mTextEdit.isBezeled		= false
			mTextEdit.usesSingleLineMode 	= false
			mTextEdit.lineBreakMode		= .byWordWrapping
			mTextEdit.formatter 		= nil
		}
	}
	#endif

	#if os(OSX)
	open override var intrinsicContentSize: KCSize {
		get {
			let colnum: Int
			switch mMode {
			case .label, .value:
				colnum = 40
			case .view(let num):
				colnum = num
			case .edit(let num):
				colnum = num
			}
			let fitsize = mTextEdit.fittingSize
			var width: CGFloat = fitsize.width
			if let font = mTextEdit.font {
				let newwidth = font.pointSize * CGFloat(colnum)
				width = max(width, newwidth)
			}
			mTextEdit.preferredMaxLayoutWidth = width
			return KCSize(width: width, height: fitsize.height)
		}
	}
	#else
	open override var intrinsicContentSize: KCSize {
		get { return mTextEdit.intrinsicContentSize }
	}
	#endif

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		mTextEdit.invalidateIntrinsicContentSize()
	}

	public override func setExpandability(holizontal holiz: KCViewBase.ExpansionPriority, vertical vert: KCViewBase.ExpansionPriority) {
		mTextEdit.setExpansionPriority(holizontal: holiz, vertical: vert)
		super.setExpandability(holizontal: holiz, vertical: vert)
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
			return getText()
		}
		set(newval) {
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					#if os(OSX)
						myself.mTextEdit.stringValue = newval
					#else
						myself.mTextEdit.text = newval
					#endif
				}
			})
		}
	}

	private func getText() -> String {
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

	private func setText(label str:String){
		CNExecuteInMainThread(doSync: false, execute: {
			[weak self] () -> Void in
			if let myself = self {
				#if os(OSX)
					myself.mTextEdit.stringValue = str
				#else
					myself.mTextEdit.text = str
				#endif
			}
		})
	}

	public var value: CNNativeValue {
		get {
			let result: CNNativeValue
			switch mMode {
			case .edit(_), .label, .view(_):
				result = .stringValue(getText())
			case .value(let format, _):
				switch format {
				case .decimal:
					if let val = Int(getText()) {
						result = .numberValue(NSNumber(integerLiteral: val))
					} else {
						result = .nullValue
					}
				case .general:
					result = .stringValue(getText())
				}
			}
			return result
		}
		set(newval) {
			let txt = newval.toText()
			let str = txt.toStrings(terminal: "").joined(separator: "\n")
			setText(label: str)
		}
	}

	public var font: CNFont? {
		get {
			return mTextEdit.font
		}
		set(font){
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					myself.mTextEdit.font = font
				}
			})
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
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					#if os(OSX)
						myself.mTextEdit.alignment = align
					#else
						myself.mTextEdit.textAlignment = align
					#endif
				}
			})
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

#if false
@objc private class KCTextEditDelegate: NSObject, NSTextFieldDelegate
{
	public typealias FormatterType = KCTextEditCore.FormatterType

	public var	 	format: 	FormatterType?
	private weak var 	mParent: 	KCTextEditCore?

	public init(parent par: KCTextEditCore) {
		mParent		= par
		format		= nil
	}

	public func controlTextDidEndEditing(_ obj: Notification) {
		guard let parent = mParent else {
			return
		}

		/* Convert text to taget value */
		let text  = parent.text
		let value : CNValue
		if let form = format {
			switch form {
			case .general:
				value = CNValue(stringValue: text)
			case .decimal:
				if let intval = Int(text) {
					value = CNValue(intValue: intval)
				} else {
					NSLog("Failed to convert int: \(text)")
					value = CNValue(intValue: 0)
				}
			}
		} else {
			value = CNValue(stringValue: text)
		}
		/* */
		if let cbfunc = parent.callbackFunction {
			cbfunc(value)
		}
	}
}
#endif

