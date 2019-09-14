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
import CoconutShell
import Foundation

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
	private var		mOutputHandle:		FileHandle
	private var		mCommandOperations: 	Dictionary<String, CommandFunction>

	public init(coreView view: KCTextViewCore, output outhdl: FileHandle) {
		mLineStartIndex		= 0
		mOutputHandle		= outhdl
		mCommandOperations	= [:]
		super.init(coreView: view)

		mCommandOperations = commandOperations()
	}

	public var lineStartIndex: Int {
		get	    { return mLineStartIndex }
		set(newidx) { mLineStartIndex = newidx}
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
		/* Adjust start index */
		if delta < 0 && erange.location <= mLineStartIndex {
			mLineStartIndex += delta
		}

		/* Check some strings after the start index */
		let srcstr = storage.string
		guard delta > 0 && mLineStartIndex < srcstr.count else {
			return
		}

		/* Collect lines terminated by newline */
		let start  = srcstr.index(srcstr.startIndex, offsetBy: mLineStartIndex)
		var i      = start
		let end    = srcstr.endIndex
		var index  = mLineStartIndex
		var lines: Array<String>   = []
		var line:  Array<Character> = []
		while i < end {
			let c = srcstr[i]
			if c == "\n" {
				if line.count > 0 {
					/* newline is required to present end of the line */
					lines.append(String(line) + "\n")
					line = []
					mLineStartIndex = index + 1
				}
			} else {
				let mc = unicodeToChar(char: c)
				line.append(mc)
			}
			i = srcstr.index(i, offsetBy: 1)
			index += 1
		}
		/* Pass lines to callbacks */
		for line in lines {
			if let data = line.data(using: .utf8) {
				mOutputHandle.write(data)
			} else {
				NSLog("[Error] Failed to convert: \(line)")
			}
		}
	}

	/*
	 * reference: https://www.cl.cam.ac.uk/~mgk25/ucs/quotes.html
	 */
	private func unicodeToChar(char c: Character) -> Character {
		let result: Character
		switch c {
		/* Smart single quotation -> ASCII quotation */
		case "\u{2018}", "\u{2019}":	result = "\u{0027}"
		/* Smart double quotation -> ASCII quotation */
		case "\u{201c}", "\u{201d}":	result = "\u{0022}"
		/* Normal -> ASCII */
		default:			result = c
		}
		return result
	}
}

