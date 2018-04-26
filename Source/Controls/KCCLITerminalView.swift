/**
 * @file	 KCCLITermnialView.swift
 * @brief Define KCCLITerminalView class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData
import Foundation

private class KCCLIConsole: CNConsole
{
	private weak var mTerminalView: KCCLITerminalView?

	public init(terminalView view: KCCLITerminalView){
		mTerminalView = view
	}

	open override func print(string str: String){
		mTerminalView?.putStandardText(string: str)
	}

	open override func error(string str: String){
		mTerminalView?.putErrorText(string: str)
	}

	open override func scan() -> String? {
		return mTerminalView?.scanInputString()
	}
}

private class KCCursor
{
	private var 	mStartPosition: 	Int
	private var	mPromptString:		String
	private var	mPromptLength:		Int
	private var	mInputOffset:		Int

	public init() {
		mStartPosition	= 0
		mPromptString	= "> "
		mPromptLength	= mPromptString.count
		mInputOffset	= 0
	}

	public func promptPosition() -> Int {
		return mStartPosition
	}

	public func inputPosition() -> Int {
		return mStartPosition + mPromptLength
	}

	public func cursorPosition() -> Int {
		return mStartPosition + mPromptLength + mInputOffset
	}

	public func countBeforeCursor() -> Int {
		return mInputOffset
	}

	public func countAfterCursor(storage strg: NSTextStorage) -> Int {
		/* -1 to keep last space in storage */
		return strg.string.count - (cursorPosition() + 1)
	}

	public func movePromptPosition(offset off: Int) {
		mStartPosition += off
		if mStartPosition < 0 {
			mStartPosition = 0
		}
	}

	public func moveInputPosition(offset off: Int){
		mInputOffset += off
		if mInputOffset < 0 {
			mInputOffset = 0
		}
	}

	public func rewindInputPosition(){
		mInputOffset = 0
	}

	public func deleteInput(number num: Int) {
		mInputOffset -= num
		if mInputOffset < 0 {
			NSLog("Too many deletes")
			mInputOffset = 0
		}
	}

	public func promptString() -> NSAttributedString {
		let pref   = KCPreference.shared.terminalPreference
		let prompt = NSAttributedString(string: mPromptString, attributes: pref.standardAttribute)
		return prompt
	}

	public func show(storage strg: NSTextStorage){
		let pos    = cursorPosition()
		let range  = NSRange(location: pos, length: 1)
		let pref   = KCPreference.shared.terminalPreference
		strg.setAttributes(pref.cursorAttributes, range: range)
	}

	public func hide(storage strg: NSTextStorage){
		let pos    = cursorPosition()
		let range  = NSRange(location: pos, length: 1)
		let pref   = KCPreference.shared.terminalPreference
		strg.setAttributes(pref.standardAttribute, range: range)
	}
}

public class KCCLITerminalView: KCTerminalView, KCTextViewDelegate
{
	private var mCursor:	KCCursor
	private var mConsole:	KCCLIConsole?

	#if os(OSX)
	public override init(frame : NSRect){
		mConsole    = nil
		mCursor	    = KCCursor()
		super.init(frame: frame) ;
		self.editor = self
		setupContext()
	}
	#else
	public override init(frame: CGRect){
		mConsole    = nil
		mCursor	    = KCCursor()
		super.init(frame: frame) ;
		self.editor = self
		setupContext()
	}
	#endif

	public convenience init(){
		self.init()
		self.editor = self
		mCursor	    = KCCursor()
		setupContext()
	}

	public required init?(coder: NSCoder) {
		mConsole    = nil
		mCursor	    = KCCursor()
		super.init(coder: coder) ;
		self.editor = self
		setupContext()
	}

	private func setupContext(){
		mConsole    = KCCLIConsole(terminalView: self)
		/* Initialize storage */
		editStorage(editor: {
			(_ storage: NSTextStorage) -> Void in
			/* Add one space for cursor */
			let pref  = KCPreference.shared.terminalPreference
			let space = NSAttributedString(string: " ", attributes: pref.standardAttribute)
			storage.setAttributedString(space)
			/* Put cursor */
			let prompt = mCursor.promptString()
			storage.insert(prompt, at: mCursor.promptPosition())
			mCursor.show(storage: storage)
		})
	}

	public func scanInputString() -> String? {
		return nil
	}

	public func putStandardText(string str: String){
		editStorage(editor: {
			(_ storage: NSTextStorage) -> Void in
			putStandardText(string: str, into: storage)
		})
	}

	private func putStandardText(string str: String, into storage: NSTextStorage){
		let pref = KCPreference.shared.terminalPreference
		let astr = NSAttributedString(string: str, attributes: pref.standardAttribute)
		storage.insert(astr, at: mCursor.promptPosition())
		mCursor.movePromptPosition(offset: str.count)
	}

	public func putErrorText(string str: String){
		editStorage(editor: {
			(_ storage: NSTextStorage) -> Void in
			putErrorText(string: str, into: storage)
		})
	}

	private func putErrorText(string str: String, into storage: NSTextStorage){
		let pref = KCPreference.shared.terminalPreference
		let astr = NSAttributedString(string: str, attributes: pref.errorAttribute)
		storage.insert(astr, at: mCursor.promptPosition())
		mCursor.movePromptPosition(offset: str.count)
	}

	public func moveForward(count cnt: Int) {
		editStorage(editor: {
			(_ storage: NSTextStorage) -> Void in
			moveForward(count: cnt, in: storage)
		})
	}

	private func moveForward(count cnt: Int, in storage: NSTextStorage){
		let n = min(mCursor.countAfterCursor(storage: storage), cnt)
		if n > 0 {
			mCursor.hide(storage: storage)
			mCursor.moveInputPosition(offset: n)
			mCursor.show(storage: storage)
		}
	}

	public func moveBackward(count cnt: Int) {
		editStorage(editor: {
			(_ storage: NSTextStorage) -> Void in
			moveBackward(count: cnt, in: storage)
		})
	}

	private func moveBackward(count cnt: Int, in storage: NSTextStorage){
		let n = min(mCursor.countBeforeCursor(), cnt)
		if n > 0 {
			mCursor.hide(storage: storage)
			mCursor.moveInputPosition(offset: -n)
			mCursor.show(storage: storage)
		}
	}

	public func insert(text txt: String, replaceRange range: NSRange) {
		editStorage(editor: {
			(storage: NSTextStorage) -> Void in
			if range.length > 0 {
				NSLog("Not supported")
			} else {
				insert(text: txt, into: storage)
			}
		})
	}

	public func insert(text txt: String, into storage: NSTextStorage) {
		let pref = KCPreference.shared.terminalPreference
		let atxt = NSAttributedString(string: txt, attributes: pref.standardAttribute)
		storage.insert(atxt, at: mCursor.cursorPosition())
		mCursor.moveInputPosition(offset: txt.count)
	}

	public func insertTab() {
		editStorage(editor: {
			(storage: NSTextStorage) -> Void in
			insert(text: "\t", into: storage)
		})
	}

	public func insertNewline() {
		editStorage(editor: {
			(storage: NSTextStorage) -> Void in
			insert(text: "\n", into: storage)
		})
	}

	public func deleteForward() {
		editStorage(editor: {
			(storage: NSTextStorage) -> Void in
			deleteForward(number: 1, in: storage)
		})
	}

	private func deleteForward(number num:Int, in storage: NSTextStorage){
		let delnum = min(mCursor.countAfterCursor(storage: storage), num)
		if delnum > 0 {
			let range = NSMakeRange(mCursor.cursorPosition(), delnum)
			storage.deleteCharacters(in: range)
			mCursor.show(storage: storage)
		}
	}

	public func deleteBackward() {
		editStorage(editor: {
			(storage: NSTextStorage) -> Void in
			deleteBackward(number: 1, in: storage)
		})
	}

	public func deleteToBeginningOfLine() {
		editStorage(editor: {
			(storage: NSTextStorage) -> Void in
			deleteToBeginningOfLine(in: storage)
		})
	}

	private func deleteToBeginningOfLine(in storage: NSTextStorage) {
		let count = mCursor.countBeforeCursor()
		if count > 0 {
			let range = NSMakeRange(mCursor.inputPosition(), count)
			storage.deleteCharacters(in: range)
			mCursor.rewindInputPosition()
		}
	}

	public func deleteToEndOfLine() {
		editStorage(editor: {
			(storage: NSTextStorage) -> Void in
			deleteToEndOfLine(in: storage)
		})
	}

	private func deleteToEndOfLine(in storage: NSTextStorage) {
		let count = mCursor.countAfterCursor(storage: storage)
		if count > 0 {
			let range = NSMakeRange(mCursor.cursorPosition(), count)
			storage.deleteCharacters(in: range)
			mCursor.show(storage: storage)
		}
	}

	private func deleteBackward(number num:Int, in storage: NSTextStorage) {
		let delnum = min(mCursor.countBeforeCursor(), num)
		if delnum > 0 {
			let curpos = mCursor.cursorPosition()
			let range  = NSMakeRange(curpos - delnum, delnum)
			storage.deleteCharacters(in: range)
			mCursor.deleteInput(number: delnum)
		}
	}
}


