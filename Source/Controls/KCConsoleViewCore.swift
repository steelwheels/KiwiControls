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
	}

	private func appendText(destinationStorage storage: NSTextStorage, string str: String){
		storage.beginEditing()

		let newstr = NSAttributedString(string: str)
		storage.append(newstr)

		storage.endEditing()
	}

	open override var intrinsicContentSize: KCSize
	{
		/* Dont have intrinsic size */
		return KCSize(width: -1.0, height: -1.0)
	}

	open override func printDebugInfo(indent idt: Int){
		super.printDebugInfo(indent: idt)
		mTextView.printDebugInfo(indent: idt+1)
	}

}

