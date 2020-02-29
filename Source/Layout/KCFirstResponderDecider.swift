/**
 * @file	KCFirstResponderDecider.swift
 * @brief	Define KCFirstResponderDecider class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import CoconutData
import Foundation

#if os(OSX)

/* Make first responder
 * reference: https://stackoverflow.com/questions/7263482/problems-setting-firstresponder-in-cocoa-mac-osx
 */
public class KCFirstResponderDecider
{
	private var mWindow:	KCWindow
	private var mConsole:	CNConsole

	public init(window win: KCWindow, console cons: CNConsole){
		mWindow		= win
		mConsole	= cons
	}

	public func decideFirstResponder(rootView view: KCRootView) -> Bool {
		return searchFirstResponder(view: view)
	}

	private func searchFirstResponder(view base: KCViewBase) -> Bool {
		let classname = String(describing: type(of: base))
		NSLog("try to makeFirstResponder(\(classname))")

		if isTextView(view: base) {
			if base.acceptsFirstResponder {
				let classname = String(describing: type(of: base))
				NSLog("makeFirstResponder(\(classname))")
				mWindow.makeFirstResponder(base)
				return true
			}
		}
		for view in base.subviews {
			if searchFirstResponder(view: view) {
				return true
			}
		}
		return false
	}

	#if os(OSX)
	private func isTextView(view v: KCViewBase) -> Bool {
		let result: Bool
		if let t = v as? NSTextField {
			result = t.isEditable
			NSLog("NSTextField -> \(result)")
		} else if let t = v as? NSTextView {
			result = t.isEditable
			NSLog("NSTextView  -> \(result)")
		} else {
			result = false
		}
		return result
	}
	#endif
}

#endif // os(OSX)

