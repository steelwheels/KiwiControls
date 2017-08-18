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
import Canary

public class KCViewConsole: CNConsole
{
	private var mConsoleView:	KCConsoleViewCore

	public init(consoleView view: KCConsoleViewCore){
		mConsoleView = view
		super.init()
	}

	/* Do not call this method from the outside */
	public override func flush(string str: String){
		//Swift.print("KCViewConsole.flush: \(str)")
		mConsoleView.appendText(string: str)
	}
}

open class KCConsoleViewCore : KCView
{
	#if os(OSX)
		@IBOutlet var mTextView: NSTextView!
	#else
		@IBOutlet weak var mTextView: UITextView!
	#endif
	
	private var mConsole:	 KCViewConsole? = nil

	public func setup(frame frm: CGRect) {
		let bounds  = CGRect(origin: CGPoint.zero, size: frm.size)
		self.bounds = bounds
		self.frame  = bounds
		mConsole    = KCViewConsole(consoleView: self)
	}

	public var console: KCViewConsole {
		get {
			if let console = mConsole {
				return console
			} else {
				fatalError("No console object")
			}
		}
	}

	public func appendText(string str: String){
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

	private func appendText(destinationStorage storage: NSTextStorage, string str: String){
		storage.beginEditing()

		let newstr = NSAttributedString(string: str)
		storage.append(newstr)

		storage.endEditing()
	}

	public func scrollToBottom(){
		#if os(OSX)
			mTextView.scrollToEndOfDocument(self)
		#else
			mTextView.selectedRange = NSRange(location: mTextView.text.characters.count, length: 0)
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
		mTextView.printDebugInfo(indent: idt+1)
	}

}

