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
	private var mTerminalInfo:	CNTerminalInfo

	private var mIsAlternativeScreen:	Bool
	private var mNormalStorage:		NSTextStorage
	private var mNormalIndex:		Int
	private var mNormalSavedIndex:		Int?
	private var mAlternativeStorage:	NSTextStorage
	private var mAlternativeIndex:		Int
	private var mAlternativeSavedIndex:	Int?

	private var mAckCallback:	((_ codes: Array<CNEscapeCode>) -> Void)?

	public override init(frame frameRect: KCRect) {
		let tpref = CNPreference.shared.terminalPreference
		mCurrentIndex 		= 0
		mTerminalInfo 		= CNTerminalInfo(width: tpref.width, height: tpref.height)
		mAckCallback  		= nil
		mIsAlternativeScreen	= false
		mNormalStorage		= NSTextStorage()
		mNormalIndex		= 0
		mNormalSavedIndex	= nil
		mAlternativeStorage	= NSTextStorage()
		mAlternativeIndex	= 0
		mAlternativeSavedIndex	= nil
		super.init(frame: frameRect)
	}

	public required init?(coder: NSCoder) {
		let tpref = CNPreference.shared.terminalPreference
		mCurrentIndex		= 0
		mTerminalInfo		= CNTerminalInfo(width: tpref.width, height: tpref.height)
		mAckCallback  		= nil
		mIsAlternativeScreen	= false
		mNormalStorage		= NSTextStorage()
		mNormalIndex		= 0
		mNormalSavedIndex	= nil
		mAlternativeStorage	= NSTextStorage()
		mAlternativeIndex	= 0
		mAlternativeSavedIndex	= nil
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

	public var isEditable: Bool {
		get {
			return mTextView.isEditable
		}
		set(newval) {
			if newval {
				mTextView.isEditable	= true
				mTextView.isSelectable	= true
			} else {
				mTextView.isEditable	= false
				mTextView.isSelectable	= true
			}
		}
	}

	public var terminalInfo: CNTerminalInfo {
		get { return mTerminalInfo }
	}

	public func setAckCallback(callback cbfunc: ((_ codes: Array<CNEscapeCode>) -> Void)?) {
		mAckCallback = cbfunc
	}

	public func setup(frame frm: CGRect){
		let tpref = CNPreference.shared.terminalPreference

		/* Set delegate */
		mTextView.delegate = self

		/* Set layout */
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

		/* Set editable */
		self.isEditable = true

		/* Set colors */
		mTextView.textColor	  = tpref.foregroundTextColor
		mTextView.backgroundColor = tpref.backgroundTextColor
		#if os(OSX)
		mTextView.insertionPointColor = tpref.foregroundTextColor
		#endif

		/* Set font */
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
		let tpref    = CNPreference.shared.terminalPreference
		let storage  = self.textStorage
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
				let (newidx, donewline) = storage.moveCursorToNextLineStart(from: mCurrentIndex, number: rownum)
				if donewline {
					mCurrentIndex = storage.append(string: "\n", font: self.font, terminalInfo: self.mTerminalInfo)
				} else {
					mCurrentIndex = newidx
				}
			case .cursorPreviousLine(let rownum):
				mCurrentIndex = storage.moveCursorToPreviousLineStart(from: mCurrentIndex, number: rownum)
			case .cursorHolizontalAbsolute(let pos):
				if pos >= 1 {
					mCurrentIndex = storage.moveCursorTo(from: mCurrentIndex, x: pos-1)
				} else {
					NSLog("cursorHolizontalAbsolute: Underflow")
				}
			case .saveCursorPosition:
				if mIsAlternativeScreen {
					mAlternativeIndex = mCurrentIndex
				} else {
					mNormalSavedIndex = mCurrentIndex
				}
			case .restoreCursorPosition:
				var nextidx: Int? = nil
				if mIsAlternativeScreen {
					nextidx = mAlternativeSavedIndex
				} else {
					nextidx = mNormalSavedIndex
				}
				if let nidx = nextidx {
					let str = self.textStorage.string
					let endidx  = str.distance(from: str.startIndex, to: str.endIndex)
					mCurrentIndex = min(nidx, endidx)
				}
			case .cursorPosition(let row, let col):
				if row>=1 && col>=1 {
					mCurrentIndex = storage.moveCursorTo(x: col-1, y: row-1)
				} else {
					NSLog("cursorPosition: Underflow")
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
				mCurrentIndex = storage.moveCursorToPreviousLineStart(from: mCurrentIndex, number: line)
			case .scrollDown(let line):
				let (newidx, _) = storage.moveCursorToNextLineStart(from: mCurrentIndex, number: line)
				mCurrentIndex = newidx
			case .resetAll:
				storage.clear(font: self.font, terminalInfo: mTerminalInfo)
				mTerminalInfo.reset()
				updateForegroundColor()
				updateBackgroundColor()
				mCurrentIndex = 0
				self.setNeedsDisplay()
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
				self.ack(escapeCodes: [ackcode])
			case .screenSize(let width, let height):
				self.mTerminalInfo.width  = width
				self.mTerminalInfo.height = height
				self.mTextView.setNeedsLayout()
			case .selectAltScreen(let doalt):
				if mIsAlternativeScreen != doalt {
					swapTextStorage(doAlternative: doalt)
					mIsAlternativeScreen = doalt
				}
			@unknown default:
				NSLog("Unknown escape code")
			}
		}

		/* Update selected range */
		let range = NSRange(location: mCurrentIndex, length: 0)
		setSelectedRange(range: range)
		mTextView.scrollRangeToVisible(range)
	}

	open func ack(escapeCodes codes: Array<CNEscapeCode>) {
		if let cbfunc = mAckCallback {
			cbfunc(codes)
		}
	}

	private func swapTextStorage(doAlternative doalt: Bool){
		if doalt {
			/* Save current storage */
			mNormalStorage.setAttributedString(self.textStorage)
			mNormalIndex = mCurrentIndex
			/* Resize */
			mAlternativeStorage.resize(width:  mTerminalInfo.width,
						   height: mTerminalInfo.height,
						   font:   self.font,
						   terminalInfo: mTerminalInfo)
			/* Set new storage */
			let storage = self.textStorage
			storage.beginEditing()
				storage.setAttributedString(mAlternativeStorage)
				self.mCurrentIndex = mAlternativeIndex
			storage.endEditing()
		} else {
			/* Save current storage */
			mAlternativeStorage.setAttributedString(self.textStorage)
			mAlternativeIndex = mCurrentIndex
			/* Set new storage */
			let storage = self.textStorage
			storage.beginEditing()
				storage.setAttributedString(mNormalStorage)
				self.mCurrentIndex = mNormalIndex
			storage.endEditing()
		}
		/* Update selected range */
		let range = NSRange(location: mCurrentIndex, length: 0)
		setSelectedRange(range: range)
		mTextView.scrollRangeToVisible(range)
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

	public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		CNExecuteInMainThread(doSync: false, execute: {
			() -> Void in
			if let key = keyPath, let vals = change {
				if let _ = vals[.newKey] as? Dictionary<CNInterfaceStyle, CNColor> {
					switch key {
					case CNPreference.shared.terminalPreference.ForegroundTextColorItem:
						self.updateForegroundColor()
					case CNPreference.shared.terminalPreference.BackgroundTextColorItem:
						self.updateBackgroundColor()
					default:
						CNLog(logLevel: .error, message: "\(#file): Unknown key (2): \(key)")
					}
				} else if let font = vals[.newKey] as? CNFont {
					switch key {
					case CNPreference.shared.terminalPreference.FontItem:
						NSLog("Change font: \(font.fontName)")
						self.updateFont()
						self.notify(viewControlEvent: .updateSize)
					default:
						NSLog("\(#file): Unknown key (3): \(key)")
					}
				} else if let _ = vals[.newKey] as? NSNumber {
					switch key {
					case CNPreference.shared.terminalPreference.WidthItem:
						let newwidth = CNPreference.shared.terminalPreference.width
						if self.mTerminalInfo.width != newwidth {
							self.mTerminalInfo.width = newwidth
							self.invalidateIntrinsicContentSize()
							self.setNeedsLayout()
							self.notify(viewControlEvent: .updateSize)
						}
					case CNPreference.shared.terminalPreference.HeightItem:
						let newheight = CNPreference.shared.terminalPreference.height
						if self.mTerminalInfo.height != newheight {
							self.mTerminalInfo.height = newheight
							self.invalidateIntrinsicContentSize()
							self.setNeedsLayout()
							self.notify(viewControlEvent: .updateSize)
						}
					case CNSystemPreference.InterfaceStyleItem:
						self.updateForegroundColor()
						self.updateBackgroundColor()
					default:
						CNLog(logLevel: .debug, message: "\(#file): Unknown key (4): \(key)")
					}
				}
			}
		})
	}

	/* Delegate of text view */
	#if os(OSX)
	public func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
		if let keybind = CNKeyBinding.decode(selectorName: commandSelector.description) {
			if let ecodes = keybind.toEscapeCode() {
				self.ack(escapeCodes: ecodes)
			}
		}
		return true // the command is processed in this method
	}
	#endif

	#if os(OSX)
	public func textView(_ textView: NSTextView, shouldChangeTextIn range: NSRange, replacementString: String?) -> Bool {
		if let str = replacementString {
			self.ack(escapeCodes: [.string(str)])
		}
		return false // the command is processed in this method
	}
	#else
	public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		self.ack(escapeCodes: [.string(text)])
		return false // the command is processed in this method
	}
	#endif

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

	private func updateForegroundColor() {
		let newcol  = CNPreference.shared.terminalPreference.foregroundTextColor
		let storage = self.textStorage
		if let curcol = mTextView.textColor {
			storage.changeOverallTextColor(targetColor: curcol, newColor: newcol)
		}
		mTerminalInfo.foregroundColor = newcol
		#if os(OSX)
			mTextView.insertionPointColor	= newcol
		#endif
	}

	private func updateBackgroundColor() {
		let newcol = CNPreference.shared.terminalPreference.backgroundTextColor
		#if os(OSX)
			let curcol = mTextView.backgroundColor
			let storage = self.textStorage
			storage.changeOverallBackgroundColor(targetColor: curcol, newColor: newcol)
		#else
			if let curcol = mTextView.backgroundColor {
				let storage = self.textStorage
				storage.changeOverallBackgroundColor(targetColor: curcol, newColor: newcol)
			}
		#endif
		mTerminalInfo.backgroundColor	= newcol
		mTextView.backgroundColor	= newcol
	}

	private func updateFont() {
		let font = CNPreference.shared.terminalPreference.font
		textStorage.changeOverallFont(font: font)
		self.invalidateIntrinsicContentSize()
	}

	private func setSelectedRange(range rng: NSRange){
		#if os(OSX)
			mTextView.setSelectedRange(rng)
		#else
			mTextView.selectedRange = rng
		#endif
	}
}

