/**
 * @file KCTextViewDelegates.swift
 * @brief Define KCTextViewDelegates class
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

public protocol KCTerminalDelegate
{
	func put(line str: String)
}

/* References:
 * Key binding: https://developer.apple.com/documentation/appkit/nsstandardkeybindingresponding
 *              https://www.hcs.harvard.edu/~jrus/site/system-bindings.html
 */
public class KCTextViewDelegates: NSObject, KCTextViewDelegate, NSTextStorageDelegate
{
	public typealias CallbackType = (_ line: String) -> Void

	private weak var 	mCoreView: 		KCTextViewCore?

	public init(coreView view: KCTextViewCore){
		mCoreView		= view
	}

	public var coreView: KCTextViewCore {
		get {
			if let view = mCoreView {
				return view
			} else {
				fatalError("Can not happen")
			}
		}
	}

	#if os(OSX)
	public func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
		fatalError("Must be override")
	}
	#endif

	#if os(OSX)
	public func textView(_ textView: NSTextView, clickedOn cell: NSTextAttachmentCellProtocol, in cellFrame: NSRect, at charIndex: Int) {
		NSLog("clicked")
	}
	#endif

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

	/* Must be override */
	open func textStorage(_ storage: NSTextStorage, range erange: NSRange, changeInLength delta: Int) {
		fatalError("Must be override")
	}

	public func currentIndex() -> Int? {
		let selranges = coreView.selectedRanges()
		if selranges.count == 1 {
			return selranges[0].location
		}
		return nil
	}
}

public class KCConsoleViewDelegates: KCTextViewDelegates
{
	public override init(coreView view: KCTextViewCore){
		super.init(coreView: view)
	}

	public override func textStorage(_ storage: NSTextStorage, range erange: NSRange, changeInLength delta: Int) {
	}

	#if os(OSX)
	public override func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
		return false
	}
	#endif
}

public class KCTerminalViewDelegates: KCTextViewDelegates
{
	typealias CommandFunction = () -> Bool

	private var		mLineStartIndex: 	Int
	private var		mTerminalDelegate:	KCTerminalDelegate?
	private var		mCommandOperations: 	Dictionary<String, CommandFunction>

	public override init(coreView view: KCTextViewCore){
		mLineStartIndex    = 0
		mTerminalDelegate  = nil
		mCommandOperations = [:]
		super.init(coreView: view)

		mCommandOperations = commandOperations()
	}

	public var terminalDelegate: KCTerminalDelegate? {
		get         { return mTerminalDelegate   }
		set(newval) { mTerminalDelegate = newval }
	}

	private func commandOperations() -> Dictionary<String, CommandFunction> {
		let result: Dictionary<String, CommandFunction> = [
			"moveUp:": { [weak self] () -> Bool in
				if let myself = self {
					return myself.moveUpCommand()
				}
				return true // No more operation
			},
			"moveLeft": { [weak self] () -> Bool in
				if let myself = self {
					return myself.moveLeftCommand()
				}
				return true // No more operation
			}
		]
		return result
	}

	private func moveUpCommand() -> Bool {
		return true // Finish operation
	}

	private func moveLeftCommand() -> Bool {
		if let idx = currentIndex() {
			return (mLineStartIndex < idx)
		} else {
			return true // No more operation
		}
	}

	#if os(OSX)
	public override func textView(_ textView: NSTextView, doCommandBy selector: Selector) -> Bool {
		let cmdname = selector.description
		if let cmdfunc = mCommandOperations[cmdname] {
			return cmdfunc()
		} else {
			return false
		}
	}
	#endif

	public override func textStorage(_ storage: NSTextStorage, range erange: NSRange, changeInLength delta: Int) {
		if delta > 0 {
			//let substr = storage.attributedSubstring(from: erange)
			//NSLog("added: \(substr.string) \(erange) \(delta) -> \(mCurrentIndex)")
			/* Set attributes for new text */
			coreView.setNormalAttributes(in: erange)
			/* If the insertion point is before current index, increase it */
			if erange.location < mLineStartIndex {
				mLineStartIndex += delta
				return
			}
			/* Collect lines terminated by newline */
			let src    = storage.string
			let start  = src.index(src.startIndex, offsetBy: mLineStartIndex)
			var i      = start
			let end    = src.endIndex
			var index  = mLineStartIndex
			var lines: Array<String>   = []
			var line: Array<Character> = []
			while i < end {
				let c = src[i]
				if c == "\n" {
					if line.count > 0 {
						lines.append(String(line))
						line = []
						mLineStartIndex = index
					}
				} else {
					line.append(c)
				}
				i = src.index(i, offsetBy: 1)
				index += 1
			}
			/* Pass lines to callbacks */
			for line in lines {
				if let tdlg = mTerminalDelegate {
					tdlg.put(line: line)
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

