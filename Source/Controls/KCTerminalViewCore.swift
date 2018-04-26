/**
 * @file	 KCTerminalViewCore.swift
 * @brief Define KCTerminalViewCore class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

public struct KCTerminalSize {
	public var width:	Int
	public var height:	Int

	init(width w: Int, height h: Int){
		width  = w
		height = h
	}
}

open class KCTerminalViewCore : KCView
{
	@IBOutlet var mTextView: KCTextView!

	private var mTerminalSize	: KCTerminalSize       = KCTerminalSize(width: 0, height: 0)

	public var editor: KCTextViewDelegate? {
		get { return mTextView.editor}
		set(editor) { return mTextView.editor = editor }
	}

	public var size: KCTerminalSize {
		get { return mTerminalSize }
	}

	public func setup(frame frm: CGRect)
	{
		let bounds  = CGRect(origin: CGPoint.zero, size: frm.size)
		self.bounds = bounds
		self.frame  = bounds

		updateTerminalSize()
	}

	public func editStorage(editor edit: (_ storage: NSTextStorage) -> Void) {
		if let storage = mTextView.textStorage {
			storage.beginEditing()
			edit(storage)
			storage.endEditing()
		} else {
			fatalError("No storage")
		}
	}

	private func updateTerminalSize() {
		let pref	= KCPreference.shared.terminalPreference
		let charsize	= fontSize(font: pref.font)
		let screensize	= self.bounds.size
		let width       = Int(screensize.width  / charsize.width)
		let height	= Int(screensize.height / charsize.height)
		mTerminalSize   = KCTerminalSize(width: width, height: height)
	}

	private func fontSize(font fnt: NSFont) -> NSSize {
		let pref = KCPreference.shared.terminalPreference
		let astr = NSAttributedString(string: "A", attributes: pref.standardAttribute)
		return astr.size()
	}

	open override var intrinsicContentSize: KCSize
	{
		#if os(OSX)
			return mTextView.intrinsicContentSize
		#else
			let cursize = mTextView.frame.size
			let maxsize = KCSize(width: cursize.width, height: cursize.height*256)
			return mTextView.sizeThatFits(maxsize)
		#endif
	}

	open override func printDebugInfo(indent idt: Int){
		super.printDebugInfo(indent: idt)
		KCPrintDebugInfo(view: mTextView,indent: idt+1)
	}
}

