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
	private weak var 	mCoreView: KCTextViewCore? = nil

	public init(coreView view: KCTextViewCore){
		mCoreView = view
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
		if editedMask.rawValue & 0x1 != 0 {
			/* Added */
			let substr = storage.attributedSubstring(from: erange)
			NSLog("added: \(substr.string) \(erange)")
			coreView.setNormalAttributes(in: erange)
		} else {
			/* Removed */
			NSLog("removed: \(erange)")
		}
	}
	#else
	public func textStorage(_ storage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range erange: NSRange, changeInLength delta: Int) {
		if editedMask.rawValue & 0x1 != 0 {
			/* Added */
			let substr = storage.attributedSubstring(from: erange)
			NSLog("added: \(substr.string) \(erange) \(delta)")
		} else {
			/* Removed */
			NSLog("removed: \(erange) \(delta)")
		}
	}
	#endif
}


