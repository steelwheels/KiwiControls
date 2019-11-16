/**
 * @file KCStorageController.swift
 * @brief Define KCStorageController class
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

public class KCStorageController: NSObject
{
	public enum TerminalMode {
		case log
		case console
	}

	public enum StreamType {
		case normal
		case error
	}

	private enum Direction {
		case forward
		case backward
		case up
		case down

		public func reverse() -> Direction {
			let result: Direction
			switch self {
			case .forward:	result = .backward
			case .backward:	result = .forward
			case .up:	result = .down
			case .down:	result = .up
			}
			return result
		}
	}

	private var		mMode:				TerminalMode
	private var		mInsertionPosition:		Int
	private var		mCurrentAttributes:		[NSAttributedString.Key: Any] = [:]

	public var insertionPosition: Int { get { return mInsertionPosition }}

	public init(mode md: TerminalMode) {
		mMode			= md
		mInsertionPosition	= 0
		super.init()

		let pref = CNPreference.shared.terminalPreference
		mCurrentAttributes[.font]	     = pref.font
		mCurrentAttributes[.foregroundColor] = KCColorTable.codeToColor(color: pref.foregroundColor)
		mCurrentAttributes[.backgroundColor] = KCColorTable.codeToColor(color: pref.backgroundColor)
	}

	/* This thread must be called in main thread */
	public func receive(textStorage storage: NSTextStorage, type typ: StreamType, data dt: Data) {
		if let str = String(data: dt, encoding: .utf8) {
			switch CNEscapeCode.decode(string: str) {
			case .ok(let codes):
				storage.beginEditing()
				for code in codes {
					self.receive(textStorage: storage, type: typ, escapeCode: code)
				}
				storage.endEditing()
			case .error(let err):
				NSLog("Failed to decode escape code: \(err.description())")
			}
		} else {
			NSLog("Failed to decode data: \(dt)")
		}
	}

	private func receive(textStorage storage: NSTextStorage, type typ: StreamType, escapeCode code: CNEscapeCode){
		//NSLog("receive = \(code.description())")
		switch code {
		case .string(let str):
			replace(textStorage: storage, type: typ, string: str)
		case .newline:
			insert(textStorage: storage, type: typ, character: "\n")
		case .tab:
			insert(textStorage: storage, type: typ, character: "\t")
		case .backspace:
			moveCursor(textStorage: storage, direction: .backward, number: 1)
		case .delete:
			deleteFromCursor(textStorage: storage, direction: .backward, number: 1)
		case .cursorUp(let n):
			moveCursor(textStorage: storage, direction: .up, number: n)
		case .cursorDown(let n):
			moveCursor(textStorage: storage, direction: .down, number: n)
		case .cursorForward(let n):
			moveCursor(textStorage: storage, direction: .forward, number: n)
		case .cursorBack(let n):
			moveCursor(textStorage: storage, direction: .backward, number: n)
		case .cursorNextLine(let n):
			moveCursor(textStorage: storage, direction: .down, number: n)
		case .cursorPreviousLine(let n):
			moveCursor(textStorage: storage, direction: .up, number: n)
		case .cursorHolizontalAbsolute(let pos):
			moveCursorTo(x: pos, y: nil)
		case .cursorPoisition(let x, let y):
			moveCursorTo(x: x, y: y)
		case .eraceFromCursorToEnd:
			deleteAllFromCursor(direction: .forward)
		case .eraceFromCursorToBegin:
			deleteAllFromCursor(direction: .backward)
		case .eraceFromBeginToEnd:
			deleteLine()
		case .eraceEntireBuffer:
			clear(textStorage: storage)
		case .scrollUp:
			break
		case .scrollDown:
			break
		case .foregroundColor(let fcol):
			set(foregroundColor: fcol)
		case .backgroundColor(let bcol):
			set(backgroundColor: bcol)
		case .setNormalAttributes:
			/* Reset to default */
			let pref = CNPreference.shared.terminalPreference
			set(foregroundColor: pref.foregroundColor)
			set(backgroundColor: pref.backgroundColor)
		}
	}

	private func set(foregroundColor col: CNColor) {
		mCurrentAttributes[.foregroundColor] = KCColorTable.codeToColor(color: col)
	}

	private func set(backgroundColor col: CNColor) {
		mCurrentAttributes[.backgroundColor] = KCColorTable.codeToColor(color: col)
	}

	private func attributedString(type typ: StreamType, string str: String) -> NSAttributedString {
		return NSAttributedString(string: str, attributes: mCurrentAttributes)
	}

	private func replace(textStorage storage: NSTextStorage, type typ: StreamType, string str: String) {
		/* Insert string to current position */
		let astr = attributedString(type: typ, string: str)
		/* Get range to replace */
		let restlen  = storage.string.count - mInsertionPosition
		let replen   = min(restlen, str.count)
		let reprange = NSRange(location: mInsertionPosition, length: replen)
		/* Replace string */
		storage.replaceCharacters(in: reprange, with: astr)
		/* Update insertion point */
		mInsertionPosition += str.count
	}

	private func insert(textStorage storage: NSTextStorage, type typ: StreamType, character ch: Character) {
		replace(textStorage: storage, type: typ, string: String(ch))
	}

	private func moveCursor(textStorage storage: NSTextStorage, direction dir: Direction, number num: Int) {
		/* normalize */
		let mdir: Direction
		let mnum: Int
		if num >= 0 {
			mdir = dir
			mnum = num
		} else {
			mdir = dir.reverse()
			mnum = -num
		}

		switch mdir {
		case .forward:
			let curlen = storage.string.count
			let newpos = min(mInsertionPosition + mnum, curlen)
			let delta  = newpos - mInsertionPosition
			if delta > 0 {
				mInsertionPosition += delta
			}
		case .backward:
			let rnum = min(mInsertionPosition, mnum)
			if rnum > 0 {
				mInsertionPosition += -rnum
			}
		case .up, .down:
			NSLog("Not supported")
		}
	}

	private func moveCursorIndex(textStorage storage: NSTextStorage, delta del: Int) {
		var newpos = mInsertionPosition + del
		if newpos < 0 {
			newpos = 0
		} else if newpos > storage.string.count {
			newpos = storage.string.count
		}
		mInsertionPosition = newpos
	}

	private func moveCursorTo(x xpos: Int?, y ypos: Int?){
		/* Not supported */
	}

	private func deleteFromCursor(textStorage storage: NSTextStorage, direction dir: Direction, number num: Int) {
		switch mMode {
		case .log:
			break
		case .console:
			switch dir {
			case .forward:
				let range = NSRange(location: mInsertionPosition, length: num)
				storage.deleteCharacters(in: range)
			case .backward:
				let rnum  = min(mInsertionPosition, num)
				if rnum > 0 {
					/* Get new point */
					let newpos = mInsertionPosition - rnum
					let range  = NSRange(location: newpos, length: rnum)
					storage.deleteCharacters(in: range)
					/* Update insertion point */
					mInsertionPosition = newpos
				}
			case .up, .down:
				break
			}
		}
	}

	private func deleteWordFromCursor(direction dir: Direction) {
		/* Not supported yet */
	}

	private func deleteAllFromCursor(direction dir: Direction) {
		/* Not supported yet */
	}

	private func deleteLine(){
		/* Not supported yet */
	}

	private func clear(textStorage storage: NSTextStorage){
		switch mMode {
		case .log:
			break
		case .console:
			storage.setAttributedString(NSAttributedString(string: ""))
			mInsertionPosition = 0
		}
	}
}


