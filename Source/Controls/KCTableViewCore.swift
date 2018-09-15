/**
 * @file	KCTableViewCore.swift
 * @brief	Define KCTableViewCore class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif

open class KCTableViewCore : KCView
{
	#if os(OSX)
	@IBOutlet weak var mTableView: NSTableView!
	#else
	@IBOutlet weak var mTableView: UITableView!
	#endif

	public func setup(frame frm: CGRect) {
		let bounds  = CGRect(origin: CGPoint.zero, size: frm.size)
		self.bounds = bounds
		self.frame  = bounds
	}

	open override var intrinsicContentSize: KCSize
	{
		return mTableView.intrinsicContentSize
	}

	open override func sizeToFit() {
		mTableView.sizeToFit()
		super.resize(mTableView.frame.size)
	}

	/*
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
			CNExecuteInMainThread(doSync: false, execute: {
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

	public var font: KCFont? {
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

	public func setColors(colors cols: KCColorPreference.TextColors){
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
*/
}

