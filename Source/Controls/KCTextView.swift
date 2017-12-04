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
import Canary
import Foundation

public protocol KCTextViewDelegate
{
	func insert(text txt: String, replaceRange range: NSRange)
	func insertTab()
	func insertNewline()

	func deleteForward()
	func deleteBackward()
}

open class KCTextView: NSTextView
{
	public var editor: KCTextViewDelegate? = nil

	open override func keyDown(with event: NSEvent) {
		super.interpretKeyEvents([event])
	}

	open override func insertText(_ string: Any, replacementRange: NSRange) {
		if let str = string as? String {
			editor?.insert(text: str, replaceRange: replacementRange)
		} else {
			NSLog("Not string")
		}
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
}
