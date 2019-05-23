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
	#if os(OSX)
	@IBOutlet weak var mTextField: NSTextField!
	#else
	@IBOutlet weak var mTextField: UILabel!
	#endif

	public func setup(frame frm: CGRect){
		self.rebounds(origin: KCPoint.zero, size: frm.size)
		#if os(OSX)
			mTextField.isBezeled		= false
			mTextField.maximumNumberOfLines	= 1
		#endif
	}

	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		return mTextField.sizeThatFits(size)
	}

	open override func sizeToFit() {
		mTextField.sizeToFit()
		super.resize(mTextField.frame.size)
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

	public var font: KCFont? {
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

	public func setColors(colors cols: KCColorPreference.TextColors){
		CNExecuteInMainThread(doSync: false, execute: {
			[weak self] () -> Void in
			if let myself = self {
				#if os(OSX)
					myself.mTextField.textColor       = cols.foreground
					myself.mTextField.drawsBackground = true
					myself.mTextField.backgroundColor = cols.background
				#else
					myself.mTextField.tintColor = cols.foreground
					myself.mTextField.textColor = cols.foreground
					myself.mTextField.backgroundColor = cols.background
				#endif
			}
		})
	}

	open override var intrinsicContentSize: KCSize {
		get {
			return mTextField.intrinsicContentSize
		}
	}
}
