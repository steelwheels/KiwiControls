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
			#if os(OSX)
				mTextField.isEnabled   = newval
			#else
				mLabel.isEnabled   = newval
			#endif
		}
	}

	public var isVisible: Bool {
		get {
			#if os(OSX)
				return !(mTextField.isHidden)
			#else
				return !(mLabel.isHidden)
			#endif

		}
		set(newval){
			#if os(OSX)
				mTextField.isHidden   = !newval
			#else
				mLabel.isHidden = !newval
			#endif
		}
	}

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

	public var font: KGFont? {
		get {
			#if os(iOS)
				return mLabel.font
			#else
				return mTextField.font
			#endif
		}
		set(font){
			#if os(iOS)
				mLabel.font = font
			#else
				mTextField.font = font
			#endif
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
			#if os(iOS)
				mLabel.textAlignment = align
			#else
				mTextField.alignment = align
			#endif
		}
	}

	public func setColors(colors cols: KGColorPreference.TextColors){
		#if os(OSX)
			mTextField.textColor       = cols.foreground
			mTextField.drawsBackground = true
			mTextField.backgroundColor = cols.background
		#else
			mLabel.tintColor = cols.foreground
			mLabel.textColor = cols.foreground
			mLabel.backgroundColor = cols.background
		#endif
	}

	open override func printDebugInfo(indent idt: Int){
		super.printDebugInfo(indent: idt)
		#if os(iOS)
			if let v = mLabel {
				v.printDebugInfo(indent: idt+1)
			}
		#else
			if let v = mTextField {
				v.printDebugInfo(indent: idt+1)
			}
		#endif
	}
}
