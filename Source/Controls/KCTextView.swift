/**
 * @file	KCTextView.swift
 * @brief Define KCTextView class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData
import Foundation

public protocol KCTextViewDelegate
{
	func moveForward(count cnt: Int)
	func moveBackward(count cnt: Int)

	func insert(text txt: String, replaceRange range: NSRange)
	func insertTab()
	func insertNewline()

	func deleteForward()
	func deleteBackward()
	func deleteToEndOfLine()
	func deleteToBeginningOfLine()
}

#if os(iOS)
	public typealias KCTextViewBase = UITextView
#else
	public typealias KCTextViewBase = NSTextView
#endif

open class KCTextView: KCTextViewBase, CNLogging
{
	public var  editor:  		KCTextViewDelegate?  = nil
	private var mConsole:		CNConsole?           = nil

	public var console: CNConsole? {
		get { return mConsole }
	}

	public func set(console cons: CNConsole){
		mConsole = cons
	}

#if os(OSX)
	open override func keyDown(with event: NSEvent) {
		super.interpretKeyEvents([event])
	}

	open override func insertText(_ string: Any, replacementRange: NSRange) {
		if let str = string as? String {
			editor?.insert(text: str, replaceRange: replacementRange)
		} else {
			log(type: .Error, string: "Not string", file: #file, line: #line, function: #function)
		}
	}

	open override func moveForward(_ sender: Any?) {
		editor?.moveForward(count: 1)
	}

	open override func moveRight(_ sender: Any?) {
		editor?.moveForward(count: 1)
	}

	open override func moveBackward(_ sender: Any?) {
		editor?.moveBackward(count: 1)
	}

	open override func moveLeft(_ sender: Any?){
		editor?.moveBackward(count: 1)
	}

	open override func insertTab(_ sender: Any?) {
		editor?.insertTab()
	}

	open override func insertNewline(_ sender: Any?){
		editor?.insertNewline()
	}

	open override func deleteForward(_ sender: Any?) {
		editor?.deleteForward()
	}

	open override func deleteBackward(_ sender: Any?) {
		editor?.deleteBackward()
	}

	open override func deleteToEndOfLine(_ sender: Any?) {
		editor?.deleteToEndOfLine()
	}

	open override func deleteToBeginningOfLine(_ sender: Any?) {
		editor?.deleteToBeginningOfLine()
	}
#endif /* os(OSX) */
}
