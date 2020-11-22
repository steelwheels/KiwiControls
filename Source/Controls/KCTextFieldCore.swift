/**
 * @file	KCTextFieldCore.swift
 * @brief	Define KCTextFieldCore class
 * @par Copyright
 *   Copyright (C) 2016-2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCTextFieldCore : KCView
{
	public enum FormatterType {
		case general
		case decimal
	}

	#if os(OSX)
	@IBOutlet weak var mTextField: NSTextField!
	#else
	@IBOutlet weak var mTextField: UILabel!
	#endif

	public func setup(frame frm: CGRect){
		KCView.setAutolayoutMode(views: [self, mTextField])
		#if os(OSX)
			mTextField.usesSingleLineMode 		= false
			mTextField.isBezeled			= false
			mTextField.maximumNumberOfLines		= 1
			mTextField.lineBreakMode		= .byTruncatingMiddle

			if let cell = mTextField.cell {
				cell.wraps		= true
				cell.isScrollable	= false
			}
		#endif
	}
	
	public func set(format form: FormatterType){
		#if os(OSX)
		switch form {
		case .general:
			mTextField.formatter = nil
		case .decimal:
			let numformatter = NumberFormatter()
			numformatter.numberStyle           = .decimal
			numformatter.maximumFractionDigits = 0
			numformatter.minimumFractionDigits = 0
			mTextField.formatter = numformatter
		}
		#endif
	}

	open override var intrinsicContentSize: KCSize {
		get { return mTextField.intrinsicContentSize }
	}

	public override func setExpandability(holizontal holiz: KCViewBase.ExpansionPriority, vertical vert: KCViewBase.ExpansionPriority) {
		let corevert: KCViewBase.ExpansionPriority
		switch vert {
		case .Fixed:		corevert = .Fixed
		case .High, .Low:	corevert = .Low
		}
		mTextField.setExpansionPriority(holizontal: holiz, vertical: corevert)
		super.setExpandability(holizontal: holiz, vertical: corevert)
	}

	public var isEnabled: Bool {
		get {
			return mTextField.isEnabled
		}
		set(newval){
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					myself.mTextField.isEnabled   = newval
				}
			})
		}
	}

	public var isBezeled: Bool {
		get {
			#if os(OSX)
				return mTextField.isBezeled
			#else
				return false
			#endif
		}
		set(newval) {
			#if os(OSX)
				mTextField.isBezeled = newval
			#else
				// Ignored
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
			return mTextField.stringValue
		#else
			if let t = mTextField.text {
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
					myself.mTextField.stringValue = str
				#else
					myself.mTextField.text = str
				#endif
			}
		})
	}

	public var font: CNFont? {
		get {
			return mTextField.font
		}
		set(font){
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					myself.mTextField.font = font
				}
			})
		}
	}

	public var textColor: CNColor? {
		get 		{ return mTextField.textColor }
		set(newcol)	{
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					#if os(OSX)
						myself.mTextField.textColor = newcol
					#else
						myself.mTextField.tintColor = newcol
					#endif
				}
			})
		}
	}

	#if os(OSX)
	public var backgroundColor: CNColor? {
		get 		{ return mTextField.backgroundColor }
		set(newcol)	{ setBackgroundColor(color: newcol) }
	}
	#else
	public override var backgroundColor: CNColor? {
		get 		{ return mTextField.backgroundColor }
		set(newcol)	{ setBackgroundColor(color: newcol) }
	}
	#endif

	private func setBackgroundColor(color col: CNColor?) {
		#if os(OSX)
		CNExecuteInMainThread(doSync: false, execute: {
			[weak self]  () -> Void in
			if let myself = self {
				myself.mTextField.backgroundColor = col
				myself.mTextField.drawsBackground = true
			}
		})
		#else
		super.backgroundColor = col
		#endif
	}

	public var alignment: NSTextAlignment {
		get {
			#if os(iOS)
				return mTextField.textAlignment
			#else
				return mTextField.alignment
			#endif
		}
		set(align){
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					#if os(iOS)
						myself.mTextField.textAlignment = align
					#else
						myself.mTextField.alignment = align
					#endif
				}
			})
		}
	}

	public var lineBreak: KCLineBreakMode {
		get {
			return mTextField.lineBreakMode
		}
		set(mode) {
			mTextField.lineBreakMode = mode
		}
	}
}
