/**
 * @file	KCTextView.swift
 * @brief Define KCTextView class
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

#if os(iOS)
	public typealias KCTextView = UITextView
#else
	public typealias KCTextView = NSTextView
#endif

extension KCTextView
{
	public func append(destinationStorage storage: NSTextStorage, string str: NSAttributedString){
		CNExecuteInMainThread(doSync: false, execute: {
			() -> Void in
			storage.beginEditing()
			storage.append(str)
			storage.endEditing()
		})
	}

	public func insert(destinationStorage storage: NSTextStorage, string str: NSAttributedString, at pos: Int) {
		CNExecuteInMainThread(doSync: false, execute: {
			() -> Void in
			storage.beginEditing()
			storage.insert(str, at: pos)
			storage.endEditing()
		})
	}

	public func clear(){
		CNExecuteInMainThread(doSync: false, execute: {
			[weak self] () -> Void in
			if let myself = self {
				#if os(OSX)
				if let storage = myself.textStorage {
					myself.clear(storage: storage)
				}
				#else
				myself.clear(storage: myself.textStorage)
				#endif

			}
		})
	}

	private func clear(storage strg: NSTextStorage){
		/* clear context */
		strg.beginEditing()
		strg.setAttributedString(NSAttributedString(string: ""))
		strg.endEditing()
	}

	func scrollToBottom(){
		#if os(OSX)
			self.scrollToEndOfDocument(self)
		#else
			self.selectedRange = NSRange(location: self.text.count, length: 0)
			self.isScrollEnabled = true

			let scrollY = self.contentSize.height - self.bounds.height
			let scrollPoint = CGPoint(x: 0, y: scrollY > 0 ? scrollY : 0)
			self.setContentOffset(scrollPoint, animated: true)
		#endif
	}
}

