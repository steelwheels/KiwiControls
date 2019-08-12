/**
 * @file KCTextStorage.swift
 * @brief Define KCTextStorage class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData
import Foundation

public class KCTextStorage: NSObject, NSTextStorageDelegate
{
	public typealias CallbackType = (_ line: String) -> Void

	private weak var 	mCoreView: KCTextViewCore?
	private var		mCurrentIndex: Int
	private var		mEnterLineCallback: CallbackType?

	public init(coreView view: KCTextViewCore){
		mCoreView		= view
		mCurrentIndex		= 0
		mEnterLineCallback	= nil
	}

	public var callback: CallbackType? {
		get { return mEnterLineCallback }
		set(newfunc) { mEnterLineCallback = newfunc }
	}

	private var coreView: KCTextViewCore {
		get {
			if let view = mCoreView {
				return view
			} else {
				fatalError("Can not happen")
			}
		}
	}

	/* Delegate for Text storage */
	#if os(OSX)
	public func textStorage(_ storage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range erange: NSRange, changeInLength delta: Int) {
		textStorage(storage, range: erange, changeInLength: delta)
	}
	#else
	public func textStorage(_ storage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range erange: NSRange, changeInLength delta: Int) {
		textStorage(storage, range: erange, changeInLength: delta)
	}
	#endif

	private func textStorage(_ storage: NSTextStorage, range erange: NSRange, changeInLength delta: Int) {
		if delta > 0 {
			//let substr = storage.attributedSubstring(from: erange)
			//NSLog("added: \(substr.string) \(erange) \(delta) -> \(mCurrentIndex)")
			/* Set attributes for new text */
			coreView.setNormalAttributes(in: erange)
			/* If the insertion point is before current index, increase it */
			if erange.location < mCurrentIndex {
				mCurrentIndex += delta
				return
			}
			/* Collect lines terminated by newline */
			let src    = storage.string
			let start  = src.index(src.startIndex, offsetBy: mCurrentIndex)
			var i      = start
			let end    = src.endIndex
			var index  = mCurrentIndex
			var lines: Array<String>   = []
			var line: Array<Character> = []
			while i < end {
				let c = src[i]
				if c == "\n" {
					if line.count > 0 {
						lines.append(String(line))
						line = []
						mCurrentIndex = index
					}
				} else {
					line.append(c)
				}
				i = src.index(i, offsetBy: 1)
				index += 1
			}
			/* Pass lines to callbacks */
			for line in lines {
				if let callback = mEnterLineCallback {
					callback(line)
				} else {
					NSLog("line: \(line)")
				}
			}
		} else if delta < 0 {
			/* Removed */
			//NSLog("removed: \(erange) \(delta) -> \(mCurrentIndex)")
		} else {
			//NSLog("Not changed")
		}
	}
}


