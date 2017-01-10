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
import KiwiGraphics

open class KCTextFieldCore : KCView
{
	#if os(OSX)
	@IBOutlet weak var mTextField: NSTextField!
	#else
	@IBOutlet weak var mLabel: UILabel!
	#endif

	public var text: String {
		get {
			return getText()
		}
		set(newval) {
			DispatchQueue.main.async(execute: {
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
		#if os(OSX)
			mTextField.stringValue = str
		#else
			mLabel.text = str
		#endif
	}

	public func setColors(colors cols: KGColorPreference.TextColors){
		#if os(OSX)
			mTextField.textColor       = cols.foreground
			mTextField.drawsBackground = true
			mTextField.backgroundColor = cols.background
		#else
			mLabel.tintColor = cols.foreground
			mLabel.backgroundColor = cols.background
		#endif
	}
}
