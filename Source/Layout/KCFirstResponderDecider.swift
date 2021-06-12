/**
 * @file	KCFirstResponderDecider.swift
 * @brief	Define KCFirstResponderDecider class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

#if os(OSX)

import CoconutData
import AppKit
import Foundation

/* Make first responder
 * reference: https://stackoverflow.com/questions/7263482/problems-setting-firstresponder-in-cocoa-mac-osx
 */
public class KCFirstResponderDecider
{
	private var mWindow:	KCWindow

	public init(window win: KCWindow){
		mWindow		= win
	}

	public func decideFirstResponder(rootView view: KCRootView) -> Bool {
		return searchFirstResponder(view: view)
	}

	private func searchFirstResponder(view base: KCViewBase) -> Bool {
		if isTextView(view: base) {
			if base.acceptsFirstResponder {
				mWindow.makeFirstResponder(base)
				return true
			}
		} else if let table = base as? KCTableView {
			if let resp = table.firstResponderView {
				mWindow.makeFirstResponder(resp)
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

	private func isTextView(view v: KCViewBase) -> Bool {
		let result: Bool
		if let t = v as? NSTextField {
			result = t.isEditable
		} else if let t = v as? NSTextView {
			result = t.isEditable
		} else {
			result = false
		}
		return result
	}
}

#endif // os(OSX)

