/**
 * @file	KCTerminalViewCore.swift
 * @brief Define KCTerminalViewCore class
 * @par Copyright
 *   Copyright (C) 2017-2020 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCTextViewCore : KCView, KCTextViewDelegate, NSTextStorageDelegate
{
	#if os(OSX)
	@IBOutlet var mTextView: NSTextView!
	@IBOutlet weak var mScrollView: NSScrollView!
	#else
	@IBOutlet var mTextView: UITextView!
	#endif

	private var mCurrentIndex:	Int
	private var mSavedIndex:	Int?
	private var mTerminalInfo:	CNTerminalInfo


	public override init(frame frameRect: KCRect) {
		let tpref = CNPreference.shared.terminalPreference
		mCurrentIndex = 0
		mSavedIndex   = nil
		mTerminalInfo = CNTerminalInfo(width: tpref.width, height: tpref.height)
		super.init(frame: frameRect)
	}

	public required init?(coder: NSCoder) {
		let tpref = CNPreference.shared.terminalPreference
		mCurrentIndex = 0
		mSavedIndex   = nil
		mTerminalInfo = CNTerminalInfo(width: tpref.width, height: tpref.height)
		super.init(coder: coder)
	}

	public var font: CNFont {
		get {
			if let fnt = mTextView.font {
				return fnt
			} else {
				let newfont = CNFont.systemFont(ofSize: CNFont.systemFontSize)
				mTextView.font = newfont
				return newfont
			}
		}
		set(newfont) {
			mTextView.font = newfont
			textStorage.changeOverallFont(font: newfont)
		}
	}

	public func setup(frame frm: CGRect){
		let tpref = CNPreference.shared.terminalPreference

		mTextView.delegate = self

		KCView.setAutolayoutMode(view: self)
		/* Default setting */
		#if os(OSX)
			mTextView.drawsBackground		= true
			mTextView.isVerticallyResizable		= true
			mTextView.isHorizontallyResizable	= true
			mTextView.insertionPointColor		= tpref.foregroundTextColor
		#else
			mTextView.isScrollEnabled		= true
		#endif

		self.font = tpref.font
	}

	private var textStorage: NSTextStorage {
		get {
			#if os(OSX)
				if let storage = self.mTextView.textStorage {
					return storage
				}
				fatalError("Can not happen")
			#else
				return self.mTextView.textStorage
			#endif
		}
	}

	public func execute(escapeCodes codes: Array<CNEscapeCode>) {
		CNExecuteInMainThread(doSync: false, execute: {
			() -> Void in
			self.executeInSync(escapeCodes: codes)
		})
	}

	public func executeInSync(escapeCodes codes: Array<CNEscapeCode>) {
		let storage = self.textStorage
		for code in codes {
			switch code {
			case .string(let str):
				mCurrentIndex = storage.write(string: str, at: mCurrentIndex, font: self.font, terminalInfo: mTerminalInfo)
			case .eot:
				break
			case .newline:
				mCurrentIndex = storage.write(string: "\n", at: mCurrentIndex, font: self.font, terminalInfo: mTerminalInfo)
			case .tab:
				mCurrentIndex = storage.write(string: "\t", at: mCurrentIndex, font: self.font, terminalInfo: mTerminalInfo)
			case .backspace:
				/* move left */
				mCurrentIndex = storage.moveCursorBackward(from: mCurrentIndex, number: 1)
			case .delete:
				/* Delete left 1 character	*/
				mCurrentIndex = storage.deleteBackwardCharacters(from: mCurrentIndex, number: 1)
			case .cursorUp(let rownum):
				mCurrentIndex = storage.moveCursorUpOrDown(from: mCurrentIndex, doUp: true, number: rownum)
			case .cursorDown(let rownum):
				mCurrentIndex = storage.moveCursorUpOrDown(from: mCurrentIndex, doUp: false, number: rownum)
			case .cursorForward(let colnum):
				mCurrentIndex = storage.moveCursorForward(from: mCurrentIndex, number: colnum)
			case .cursorBackward(let colnum):
				mCurrentIndex = storage.moveCursorBackward(from: mCurrentIndex, number: colnum)
			case .cursorNextLine(let rownum):
				mCurrentIndex = storage.moveCursorUpOrDown(from: mCurrentIndex, doUp: false, number: rownum)
			case .cursorPreviousLine(let rownum):
				mCurrentIndex = storage.moveCursorUpOrDown(from: mCurrentIndex, doUp: true, number: rownum)
			case .cursorHolizontalAbsolute(let pos):
				if pos >= 1 {
					mCurrentIndex = storage.moveCursorTo(from: mCurrentIndex, x: pos-1)
				} else {
					NSLog("cursorHolizontalAbsolute: Underflow")
				}
			case .saveCursorPosition:
				mSavedIndex = mCurrentIndex
			case .restoreCursorPosition:
				if let savedidx = mSavedIndex {
					let str = self.textStorage.string
					let endidx  = str.distance(from: str.startIndex, to: str.endIndex)
					mCurrentIndex = min(savedidx, endidx)
				}
			case .cursorPosition(let row, let col):
				if row>=1 && col>=1 {
					mCurrentIndex = storage.moveCursorTo(base: mCurrentIndex, x: col-1, y: row-1)
				} else {
					NSLog("cursorHolizontalAbsolute: Underflow")
				}
			case .eraceFromCursorToEnd:
				mCurrentIndex = storage.deleteForwardAllCharacters(from: mCurrentIndex)
			case .eraceFromCursorToBegin:
				mCurrentIndex = storage.deleteBackwardAllCharacters(from: mCurrentIndex)
			case .eraceEntireBuffer:
				storage.clear(font: self.font, terminalInfo: mTerminalInfo)
				mCurrentIndex = 0
			case .eraceEntireLine:
				mCurrentIndex = storage.deleteEntireLine(from: mCurrentIndex)
			case .eraceFromCursorToRight:
				mCurrentIndex = storage.deleteForwardAllCharacters(from: mCurrentIndex)
			case .eraceFromCursorToLeft:
				mCurrentIndex = storage.deleteBackwardAllCharacters(from: mCurrentIndex)
			case .scrollUp(let line):
				mCurrentIndex = storage.scrollUp(lines: line, font: self.font, terminalInfo: mTerminalInfo)
			case .scrollDown(let line):
				mCurrentIndex = storage.scrollDown(lines: line, font: self.font, terminalInfo: mTerminalInfo)
			case .resetAll:
				storage.clear(font: self.font, terminalInfo: mTerminalInfo)
				mTerminalInfo.reset()
				mCurrentIndex = 0
				self.setNeedsLayout()
			case .resetCharacterAttribute:
				mTerminalInfo.reset()
				self.setNeedsDisplay()
			case .boldCharacter(let flag):
				mTerminalInfo.doBold = flag
				self.setNeedsDisplay()
			case .underlineCharacter(let flag):
				mTerminalInfo.doUnderLine = flag
				self.setNeedsDisplay()
			case .blinkCharacter(_),
			     .reverseCharacter(_):
				NSLog("Not supported: \(code.description())")
			case .foregroundColor(let color):
				mTerminalInfo.foregroundColor = color
				self.setNeedsDisplay()
			case .defaultForegroundColor:
				let tpref = CNPreference.shared.terminalPreference
				mTerminalInfo.foregroundColor = tpref.foregroundTextColor
				self.setNeedsDisplay()
			case .backgroundColor(let color):
				mTerminalInfo.backgroundColor = color
				self.setNeedsDisplay()
			case .defaultBackgroundColor:
				let tpref = CNPreference.shared.terminalPreference
				mTerminalInfo.backgroundColor = tpref.backgroundTextColor
				self.setNeedsDisplay()
			case .requestScreenSize:
				/* Ack the size*/
				let ackcode: CNEscapeCode = .screenSize(self.mTerminalInfo.width, self.mTerminalInfo.height)
				self.ack(escapeCode: ackcode)
			case .screenSize(let width, let height):
				self.mTerminalInfo.width  = width
				self.mTerminalInfo.height = height
				self.mTextView.setNeedsLayout()
			case .selectAltScreen(_):
				NSLog("Not supported: \(code.description())")
			@unknown default:
				NSLog("Unknown escape code")
			}
		}
	}

	public func ack(escapeCode code: CNEscapeCode) {
	}

	public override var intrinsicContentSize: KCSize {
		get { return targetSize() }
	}

	public override func setFrameSize(_ newsize: KCSize) {
		//CNLog(logLevel: .debug, message: "KCTerminalViewCore: setFrameSize: \(newsize.description)")
		#if os(OSX)
			mScrollView.setFrameSize(newsize)
			let barwidth = scrollBarWidth()
			let txtsize  = KCSize(width: max(newsize.width - barwidth, 0), height: newsize.height)
			mTextView.setFrameSize(txtsize)
		#else
			mTextView.setFrameSize(size: newsize)
		#endif
		super.setFrameSize(newsize)
		/* Update terminal size info */
		updateTerminalSize()
	}

	public override func setExpandabilities(priorities prival: KCViewBase.ExpansionPriorities) {
		mTextView.setExpansionPriorities(priorities: prival)
		super.setExpandabilities(priorities: prival)
	}

	private func targetSize() -> KCSize {
		let tpref      = CNPreference.shared.terminalPreference
		let fontsize   = fontSize()
		let termwidth  = CGFloat(tpref.width)  * fontsize.width
		let termheight = CGFloat(tpref.height) * fontsize.height
		let barwidth   = scrollBarWidth()
		let termsize   = KCSize(width: termwidth + barwidth, height: termheight)
		//CNLog(logLevel: .detail, message: "KCTerminalViewCore: target size \(termsize.description)")
		return termsize
	}

	private func scrollBarWidth() -> CGFloat {
		#if os(OSX)
			if let scrl = mScrollView.verticalScroller {
				return scrl.frame.size.width
			} else {
				return 0.0
			}
		#else
			return 0.0
		#endif
	}

	private func fontSize() -> KCSize {
		let attr = [NSAttributedString.Key.font: self.font]
		let str: String = " "
		return str.size(withAttributes: attr)
	}

	private func updateTerminalSize() {
		let viewsize	= mTextView.frame.size
		let fontsize	= fontSize()
		let barwidth    = scrollBarWidth()
		let newwidth	= Int(max(viewsize.width - barwidth, 0.0)  / fontsize.width )
		let newheight   = Int(viewsize.height / fontsize.height)
		//NSLog("updateTerminalInfo: \(newwidth) \(newheight)")
		mTerminalInfo.width	= newwidth
		mTerminalInfo.height	= newheight
	}
}

