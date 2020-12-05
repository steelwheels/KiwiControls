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

open class KCTextEditCore : KCView
{
	public enum FormatterType {
		case general
		case decimal
	}

	public typealias CallbackFunction = (_ value: CNValue) -> Void

	#if os(OSX)
	@IBOutlet weak var mTextEdit: NSTextField!
	private var	mTextEditDelegate:	KCTextEditDelegate? = nil
	#else
	@IBOutlet weak var mTextEdit: UITextField!
	#endif

	public var 	callbackFunction:	CallbackFunction? = nil

	public func setup(frame frm: CGRect){
		KCView.setAutolayoutMode(views: [self, mTextEdit])
		#if os(OSX)
			mTextEdit.usesSingleLineMode 	= false
			mTextEdit.isBezeled		= true
			mTextEdit.maximumNumberOfLines	= 1
			mTextEdit.lineBreakMode		= .byCharWrapping

			if let cell = mTextEdit.cell {
				cell.wraps		= true
				cell.isScrollable	= false
			}
		#endif


		#if os(OSX)
			let delegate = KCTextEditDelegate(parent: self)
			mTextEdit.delegate = delegate
			mTextEditDelegate = delegate
		#else
			mTextEdit.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
		#endif
	}

	#if os(iOS)
	@objc public func textFieldDidChange(_ textField: KCTextField) {
		let value = CNValue(stringValue: self.text)
		if let cbfunc = self.callbackFunction {
			cbfunc(value)
		}
	}
	#endif

	public func set(format form: FormatterType){
		#if os(OSX)
		switch form {
		case .general:
			mTextEdit.formatter = nil
		case .decimal:
			let numformatter = NumberFormatter()
			numformatter.numberStyle           = .decimal
			numformatter.maximumFractionDigits = 0
			numformatter.minimumFractionDigits = 0
			mTextEdit.formatter = numformatter

			mTextEdit.usesSingleLineMode 	= true
			mTextEdit.maximumNumberOfLines	= 1
		}
		if let dlg = mTextEditDelegate {
			dlg.format = form
		}
		#endif
	}

	open override var intrinsicContentSize: KCSize {
		get { return mTextEdit.intrinsicContentSize }
	}

	public override func setExpandability(holizontal holiz: KCViewBase.ExpansionPriority, vertical vert: KCViewBase.ExpansionPriority) {
		mTextEdit.setExpansionPriority(holizontal: holiz, vertical: vert)
		super.setExpandability(holizontal: holiz, vertical: vert)
	}

	public var isEnabled: Bool {
		get {
			return mTextEdit.isEnabled
		}
		set(newval){
			mTextEdit.isEnabled = newval
		}
	}

	public var isEditable: Bool {
		get {
			#if os(OSX)
				return mTextEdit.isEditable
			#else
				return true
			#endif
		}
		set(newval){
			#if os(OSX)
				mTextEdit.isEditable = newval
			#endif
		}
	}

	public var isBezeled: Bool {
		get {
			#if os(OSX)
				return mTextEdit.isBezeled
			#else
				return mTextEdit.borderStyle == .bezel
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

	public var text: String {
		get {
			return getText()
		}
		set(newval) {
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					myself.setText(label: newval)
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
	public var lineBreak: KCLineBreakMode {
		get {
			return mTextEdit.lineBreakMode
		}
		set(mode) {
			mTextEdit.lineBreakMode = mode
		}
	}
	#endif
	
	public func setColors(colors cols: KCColorPreference.TextColors){
		CNExecuteInMainThread(doSync: false, execute: {
			[weak self] () -> Void in
			if let myself = self {
				#if os(OSX)
					myself.mTextEdit.textColor       = cols.foreground
					myself.mTextEdit.drawsBackground = true
					myself.mTextEdit.backgroundColor = cols.background
				#else
					myself.mTextEdit.tintColor = cols.foreground
					myself.mTextEdit.textColor = cols.foreground
					myself.mTextEdit.backgroundColor = cols.background
				#endif
			}
		})
	}
}

#if os(OSX)
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

