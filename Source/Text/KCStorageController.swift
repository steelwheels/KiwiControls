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
			append(textStorage: storage, type: typ, string: str)
		case .newline:
			append(textStorage: storage, type: typ, character: "\n")
		case .tab:
			append(textStorage: storage, type: typ, character: "\t")
		case .backspace:
			moveCursorBackward(textStorage: storage, number: 1)
		case .delete:
			deleteBackwardCharacters(textStorage: storage, number: 1)
		case .cursorUp(let n):
			moveCursorUp(textStorage: storage, number: n)
		case .cursorDown(let n):
			moveCursorDown(textStorage: storage, number: n)
		case .cursorForward(let n):
			moveCursorForward(textStorage: storage, number: n)
		case .cursorBack(let n):
			moveCursorBackward(textStorage: storage, number: n)
		case .cursorNextLine(let n):
			moveCursorNextLine(textStorage: storage, number: n)
		case .cursorPreviousLine(let n):
			moveCursorPreviousLine(textStorage: storage, number: n)
		case .cursorHolizontalAbsolute(let pos):
			moveCursorTo(x: pos, y: nil)
		case .cursorPoisition(let x, let y):
			moveCursorTo(x: x, y: y)
		case .eraceFromCursorToEnd:
			deleteForwardAllCharacters(textStorage: storage)
		case .eraceFromCursorToBegin:
			deleteBackwardAllCharacters(textStorage: storage)
		case .eraceFromCursorToRight:
			deleteForwardCharacters(textStorage: storage, number: 1)
		case .eraceFromCursorToLeft:
			deleteBackwardCharacters(textStorage: storage, number: 1)
		case .eraceEntireLine:
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

	private func append(textStorage storage: NSTextStorage, type typ: StreamType, string str: String) {
		let astr = attributedString(type: typ, string: str)
		/* Insert string to current position */
		mInsertionPosition = storage.write(string: astr, at: mInsertionPosition)
	}

	private func append(textStorage storage: NSTextStorage, type typ: StreamType, character ch: Character) {
		append(textStorage: storage, type: typ, string: String(ch))
	}

	private func moveCursorForward(textStorage storage: NSTextStorage, number num: Int) {
		switch mMode {
		case .log:	break
		case .console:	mInsertionPosition = storage.moveCursorForward(from: mInsertionPosition, number: num)
		}
	}

	private func moveCursorBackward(textStorage storage: NSTextStorage, number num: Int) {
		switch mMode {
		case .log:	break
		case .console:	mInsertionPosition = storage.moveCursorBackward(from: mInsertionPosition, number: num)
		}
	}

	private func moveCursorUp(textStorage storage: NSTextStorage, number num: Int) {
		switch mMode {
		case .log:	break
		case .console:	mInsertionPosition = storage.moveCursorUp(from: mInsertionPosition, number: num, moveToHead: false)
		}
	}

	private func moveCursorDown(textStorage storage: NSTextStorage, number num: Int) {
		switch mMode {
		case .log:	break
		case .console:	mInsertionPosition = storage.moveCursorDown(from: mInsertionPosition, number: num, moveToHead: false)
		}
	}

	private func moveCursorPreviousLine(textStorage storage: NSTextStorage, number num: Int) {
		switch mMode {
		case .log:	break
		case .console:	mInsertionPosition = storage.moveCursorUp(from: mInsertionPosition, number: num, moveToHead: true)
		}
	}

	private func moveCursorNextLine(textStorage storage: NSTextStorage, number num: Int) {
		switch mMode {
		case .log:	break
		case .console:	mInsertionPosition = storage.moveCursorDown(from: mInsertionPosition, number: num, moveToHead: true)
		}
	}

	private func moveCursorTo(x xpos: Int?, y ypos: Int?){
		/* Not supported */
	}

	private func deleteForwardCharacters(textStorage storage: NSTextStorage, number num: Int) {
		switch mMode {
		case .log:	break
		case .console:	mInsertionPosition = storage.deleteForwardCharacters(at: mInsertionPosition, number: num)
		}
	}

	private func deleteForwaredWord(direction dir: Direction) {
		/* Not supported yet */
	}

	private func deleteForwardAllCharacters(textStorage storage: NSTextStorage) {
		switch mMode {
		case .log:	break
		case .console:	mInsertionPosition = storage.deleteForwardAllCharacters(at: mInsertionPosition)
		}
	}

	private func deleteBackwardCharacters(textStorage storage: NSTextStorage, number num: Int) {
		switch mMode {
		case .log:	break
		case .console:	mInsertionPosition = storage.deleteBackwardCharacters(at: mInsertionPosition, number: num)
		}
	}

	private func deleteBackwardAllCharacters(textStorage storage: NSTextStorage){
		switch mMode {
		case .log:	break
		case .console:	mInsertionPosition = storage.deleteBackwardAllCharacters(at: mInsertionPosition)
		}
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


