/**
 * @file	KCConsoleViewCore.swift
 * @brief Define KCConsoleViewCore class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCConsoleViewCore : KCView
{
	#if os(OSX)
		@IBOutlet var mTextView: NSTextView!
	#else
		@IBOutlet weak var mTextView: UITextView!
	#endif

	public func setup(frame frm: CGRect) {
		let bounds  = CGRect(origin: CGPoint.zero, size: frm.size)
		self.bounds = bounds
		self.frame  = bounds
	}

	open override func sizeToFit() {
		mTextView.sizeToFit()
		super.resize(mTextView.frame.size)
	}

	public func appendText(string str: NSAttributedString){
		#if os(OSX)
			if let storage = mTextView.textStorage {
				appendText(destinationStorage: storage, string: str)
			}
		#else
			let storage = mTextView.textStorage
			appendText(destinationStorage: storage, string: str)
		#endif
		scrollToBottom()
	}

	private func appendText(destinationStorage storage: NSTextStorage, string str: NSAttributedString){
		CNExecuteInMainThread(doSync: false, execute: {
			() -> Void in
			storage.beginEditing()
			storage.append(str)
			storage.endEditing()
		})
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
		return mTextView.intrinsicContentSize
	}
}

