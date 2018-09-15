/**
 * @file	KCTextEditCore.swift
 * @brief	Define KCTextEditCore class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

#if os(OSX)
import Cocoa
#else
import UIKit
#endif
import CoconutData

open class KCTextEditCore : KCView
{
	#if os(OSX)
	@IBOutlet weak var mTextEdit: NSTextField!
	#else
	@IBOutlet weak var mTextEdit: UITextField!
	#endif

	public func setup(frame frm: CGRect){
		let bounds  = CGRect(origin: CGPoint.zero, size: frm.size)
		self.frame  = bounds
		self.bounds = bounds
		#if os(OSX)
			mTextEdit.isBezeled		= true
			mTextEdit.maximumNumberOfLines	= 0
		#endif
	}

	open override func sizeToFit() {
		mTextEdit.sizeToFit()
		super.resize(mTextEdit.frame.size)
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
		CNExecuteInMainThread(doSync: false, execute: { () -> Void in
			#if os(OSX)
			self.mTextEdit.stringValue = str
			#else
			self.mTextEdit.text = str
			#endif
		})
	}

	public var font: KCFont? {
		get {
			return mTextEdit.font
		}
		set(font){
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				self.mTextEdit.font = font
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
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				#if os(OSX)
					self.mTextEdit.alignment = align
				#else
					self.mTextEdit.textAlignment = align
				#endif
			})
		}
	}

	open override var intrinsicContentSize: KCSize {
		get {
			return mTextEdit.intrinsicContentSize
		}
	}

	public func setColors(colors cols: KCColorPreference.TextColors){
		CNExecuteInMainThread(doSync: false, execute: { () -> Void in
			#if os(OSX)
			self.mTextEdit.textColor       = cols.foreground
			self.mTextEdit.drawsBackground = true
			self.mTextEdit.backgroundColor = cols.background
			#else
			self.mTextEdit.tintColor = cols.foreground
			self.mTextEdit.textColor = cols.foreground
			self.mTextEdit.backgroundColor = cols.background
			#endif
		})
	}
}

