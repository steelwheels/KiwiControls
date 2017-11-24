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
import Canary

open class KCTerminalViewCore : KCView
{
	@IBOutlet weak var mTextView: NSTextView!

	public func setup(frame frm: CGRect) {
		let bounds  = CGRect(origin: CGPoint.zero, size: frm.size)
		self.bounds = bounds
		self.frame  = bounds
	}

	public func appendText(string str: NSAttributedString){
		editStorage(editor: { (_ storage: NSTextStorage) -> Void in
			storage.append(str)
		})
	}

	private func editStorage(editor edit: (_ storage: NSTextStorage) -> Void) {
		if let storage = mTextView.textStorage {
			storage.beginEditing()
				edit(storage)
			storage.endEditing()
		}
	}

	public func scrollToBottom(){
		#if os(OSX)
			mTextView.scrollToEndOfDocument(self)
		#else
			mTextView.selectedRange = NSRange(location: mTextView.text.count, length: 0)
			mTextView.isScrollEnabled = true

			let scrollY = mTextView.contentSize.height - mTextView.bounds.height
			let scrollPoint = CGPoint(x: 0, y: scrollY > 0 ? scrollY : 0)
			mTextView.setContentOffset(scrollPoint, animated: true)
		#endif
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

