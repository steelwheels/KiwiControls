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
	@IBOutlet weak var mLabel: UILabel!
	#endif

	public func setup(frame frm: CGRect){
		let bounds  = CGRect(origin: CGPoint.zero, size: frm.size)
		self.frame  = bounds
		self.bounds = bounds
	}

	public var isEnabled: Bool {
		get {
			#if os(OSX)
				return mTextField.isEnabled
			#else
				return mLabel.isEnabled
			#endif
		}
		set(newval){
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				#if os(OSX)
					self.mTextField.isEnabled   = newval
				#else
					self.mLabel.isEnabled   = newval
				#endif
			})
		}
	}

	public var text: String {
		get {
			return getText()
		}
		set(newval) {
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				self.setText(label: newval)
			})
		}
	}

	private func getText() -> String {
		#if os(OSX)
			return mTextField.stringValue
		#else
			if let t = mLabel.text {
				return t
			} else {
				return ""
			}
		#endif
	}

	private func setText(label str:String){
		CNExecuteInMainThread(doSync: false, execute: { () -> Void in
			#if os(OSX)
				self.mTextField.stringValue = str
			#else
				self.mLabel.text = str
			#endif
		})
	}

	public var font: KCFont? {
		get {
			#if os(iOS)
				return mLabel.font
			#else
				return mTextField.font
			#endif
		}
		set(font){
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				#if os(iOS)
					self.mLabel.font = font
				#else
					self.mTextField.font = font
				#endif
			})
		}
	}

	public var alignment: NSTextAlignment {
		get {
			#if os(iOS)
				return mLabel.textAlignment
			#else
				return mTextField.alignment
			#endif
		}
		set(align){
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				#if os(iOS)
					self.mLabel.textAlignment = align
				#else
					self.mTextField.alignment = align
				#endif
			})
		}
	}

	public var lineBreak: KCLineBreakMode {
		get {
			#if os(iOS)
				return mLabel.lineBreakMode

			#else
				return mTextField.lineBreakMode
			#endif
		}
		set(mode) {
			#if os(iOS)
				mLabel.lineBreakMode = mode
			#else
				mTextField.lineBreakMode = mode
			#endif
		}
	}

	public func setColors(colors cols: KCColorPreference.TextColors){
		CNExecuteInMainThread(doSync: false, execute: { () -> Void in
			#if os(OSX)
				self.mTextField.textColor       = cols.foreground
				self.mTextField.drawsBackground = true
				self.mTextField.backgroundColor = cols.background
			#else
				self.mLabel.tintColor = cols.foreground
				self.mLabel.textColor = cols.foreground
				self.mLabel.backgroundColor = cols.background
			#endif
		})
	}

	open override var intrinsicContentSize: KCSize
	{
		#if os(OSX)
			return mTextField.intrinsicContentSize
		#else
			return mLabel.intrinsicContentSize
		#endif
	}
}
