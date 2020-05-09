/**
 * @file	KCTextViewCore.swift
 * @brief Define KCTextViewCore class
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
	private let MinimumColumnNumber		= 10
	private let MinimumRowNumber		= 10

	public enum TerminalMode {
		case log
		case console
	}

	#if os(OSX)
		@IBOutlet var mTextView: NSTextView!
	#else
		@IBOutlet weak var mTextView: UITextView!
	#endif

	private var mInputPipe:			Pipe
	private var mOutputPipe:		Pipe
	private var mErrorPipe:			Pipe
	private var mCurrentIndex:		String.Index?
	private var mForegroundTextColor:	CNColor?
	private var mBackgroundTextColor:	CNColor?
	private var mDoBold:			Bool
	private var mDoItalic:			Bool
	private var mDoUnderline:		Bool
	private var mDoReverse:			Bool
	private var mFont:			CNFont
	private var mCurrentColumnNumbers:	Int
	private var mCurrentRowNumbers:		Int

	public override init(frame frameRect: KCRect) {
		mInputPipe			= Pipe()
		mOutputPipe			= Pipe()
		mErrorPipe			= Pipe()
		mCurrentIndex			= nil
		mForegroundTextColor		= nil
		mBackgroundTextColor		= nil
		mDoBold				= false
		mDoItalic			= false
		mDoUnderline			= false
		mDoReverse			= false
		mFont				= CNFont.systemFont(ofSize: CNFont.systemFontSize)
		mCurrentColumnNumbers		= 10
		mCurrentRowNumbers		= 10
		super.init(frame: frameRect)
	}

	public required init?(coder: NSCoder) {
		mInputPipe			= Pipe()
		mOutputPipe			= Pipe()
		mErrorPipe			= Pipe()
		mCurrentIndex			= nil
		mForegroundTextColor		= nil
		mBackgroundTextColor		= nil
		mDoBold				= false
		mDoItalic			= false
		mDoUnderline			= false
		mDoReverse			= false
		mFont				= CNFont.systemFont(ofSize: CNFont.systemFontSize)
		mCurrentColumnNumbers		= 10
		mCurrentRowNumbers		= 10
		super.init(coder: coder)
	}

	deinit {
		mOutputPipe.fileHandleForReading.readabilityHandler = nil
		mErrorPipe.fileHandleForReading.readabilityHandler  = nil

		/* Stop to observe */
		let pref = CNPreference.shared.terminalPreference
		pref.removeObserver(observer: self, forKey: pref.ColumnNumberItem)
		pref.removeObserver(observer: self, forKey: pref.RowNumberItem)
		pref.removeObserver(observer: self, forKey: pref.ForegroundTextColorItem)
		pref.removeObserver(observer: self, forKey: pref.BackgroundTextColorItem)
		pref.removeObserver(observer: self, forKey: pref.FontItem)

		let syspref = CNPreference.shared.systemPreference
		syspref.removeObserver(observer: self, forKey: syspref.InterfaceStyleItem)
	}

	public var inputFileHandle: FileHandle {
		get { return mInputPipe.fileHandleForReading }
	}

	public var outputFileHandle: FileHandle {
		get { return mOutputPipe.fileHandleForWriting }
	}

	public var errorFileHandle: FileHandle {
		get { return mErrorPipe.fileHandleForWriting }
	}

	public var foregroundTextColor: CNColor {
		get {
			if let col = mForegroundTextColor {
				return col
			} else {
				let pref = CNPreference.shared.terminalPreference
				return pref.foregroundTextColor
			}
		}
		set(newcol) {
			mForegroundTextColor = newcol
		}
	}

	public var backgroundTextColor: CNColor {
		get {
			if let col = mBackgroundTextColor {
				return col
			} else {
				let pref = CNPreference.shared.terminalPreference
				return pref.backgroundTextColor
			}
		}
		set(newcol) {
			mBackgroundTextColor = newcol
		}
	}

	public var font: CNFont {
		get { return mFont }
		set(newfont) {
			mTextView.typingAttributes[NSAttributedString.Key.font] = newfont
			textStorage.changeOverallFont(font: newfont)
			mFont = newfont
		}
	}

	public func setup(mode md: TerminalMode, frame frm: CGRect)
	{
		KCView.setAutolayoutMode(views: [self])
		mTextView.translatesAutoresizingMaskIntoConstraints = true
		mTextView.autoresizesSubviews = false

		let pref = CNPreference.shared.terminalPreference
		self.font = pref.font
		self.mCurrentColumnNumbers	= pref.columnNumber
		self.mCurrentRowNumbers		= pref.rowNumber

		#if os(OSX)
			mTextView.drawsBackground	  = true
			mTextView.isVerticallyResizable   = true
			mTextView.isHorizontallyResizable = true
			mTextView.insertionPointColor	  = pref.foregroundTextColor
		#else
			mTextView.isScrollEnabled = true
		#endif
		switch md {
		case .log:
			mTextView.isEditable			= false
			mTextView.isSelectable			= false
		case .console:
			mTextView.isEditable			= true
			mTextView.isSelectable			= true
		}
		mTextView.delegate = self

		/* Allocate storage */
		#if os(OSX)
			guard let storage = mTextView.textStorage else {
				NSLog("[Error] No storage")
				return
			}
		#else
			let storage = mTextView.textStorage
		#endif
		storage.delegate = self
		mCurrentIndex = storage.string.startIndex

		/* Set colors */
		mTextView.textColor = pref.foregroundTextColor
		#if os(OSX)
			mTextView.insertionPointColor = pref.foregroundTextColor
		#endif
		mTextView.backgroundColor = pref.backgroundTextColor

		mOutputPipe.fileHandleForReading.readabilityHandler = {
			[weak self]  (_ hdl: FileHandle) -> Void in
			if let myself = self {
				let data = hdl.availableData
				CNExecuteInMainThread(doSync: false, execute: {
					() -> Void in
					myself.receiveInputStream(inputData: data)
					myself.scrollToBottom()
				})
			}
		}
		mErrorPipe.fileHandleForReading.readabilityHandler = {
			[weak self]  (_ hdl: FileHandle) -> Void in
			if let myself = self {
				let data = hdl.availableData
				CNExecuteInMainThread(doSync: false, execute: {
					myself.receiveInputStream(inputData: data)
					myself.scrollToBottom()
				})
			}
		}

		/* Start observe */
		pref.addObserver(observer: self, forKey: pref.ColumnNumberItem)
		pref.addObserver(observer: self, forKey: pref.RowNumberItem)
		pref.addObserver(observer: self, forKey: pref.ForegroundTextColorItem)
		pref.addObserver(observer: self, forKey: pref.BackgroundTextColorItem)
		pref.addObserver(observer: self, forKey: pref.FontItem)

		let syspref = CNPreference.shared.systemPreference
		syspref.addObserver(observer: self, forKey: syspref.InterfaceStyleItem)
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

	private func receiveInputStream(inputData data: Data) {
		if let str = String(data: data, encoding: .utf8) {
			switch CNEscapeCode.decode(string: str) {
			case .ok(let codes):
				guard var curidx = mCurrentIndex else {
					NSLog("No current index")
					return
				}

				let storage = textStorage
				storage.beginEditing()
				for code in codes {
					var foreground: CNColor = foregroundTextColor
					var background: CNColor = backgroundTextColor
					if mDoReverse {
						let tmp    = foreground
						foreground = background
						background = tmp
					}
					let format  = CNStringFormat(foregroundColor:	foreground,
								     backgroundColor:	background,
								     doBold: 		mDoBold,
								     doItalic:		mDoItalic,
								     doUnderline:	mDoUnderline,
								     doReverse:		mDoReverse)
					let base = storage.string.index(storage.string.startIndex, offsetBy: verticalOffset())
					if let newidx = storage.execute(base:		base,
									index:		curidx,
									doInsert: 	false,
									font:		mFont,
									format: 	format,
									escapeCode: code) {
						curidx = newidx
					} else {
						executeCommandInView(escapeCode: code)
					}
				}
				storage.endEditing()
				/* Update selected range */
				let loc   = storage.string.distance(from: storage.string.startIndex, to: curidx)
				let range = NSRange(location: loc, length: 0)
				setSelectedRange(range: range)
				mCurrentIndex = curidx
			case .error(let err):
				NSLog("Failed to decode escape code: \(err.description())")
			}
		} else {
			NSLog("Failed to decode data: \(data)")
		}
	}

	public func setSelectedRange(range rng: NSRange){
		#if os(OSX)
			mTextView.setSelectedRange(rng)
		#else
			mTextView.selectedRange = rng
		#endif
	}

	private func executeCommandInView(escapeCode code: CNEscapeCode){
		switch code {
		case .scrollUp:
			break
		case .scrollDown:
			break
		case .boldCharacter(let flag):
			mDoBold = flag
		case .underlineCharacter(let flag):
			mDoUnderline = flag
		case .blinkCharacter(let flag):
			NSLog("Blink character setting is ignored: \(flag)")
		case .reverseCharacter(let flag):
			mDoReverse = flag
		case .foregroundColor(let fcol):
			mForegroundTextColor = fcol
		case .defaultForegroundColor:
			mForegroundTextColor = nil
		case .backgroundColor(let bcol):
			mBackgroundTextColor = bcol
		case .defaultBackgroundColor:
			mBackgroundTextColor = nil
		case .resetCharacterAttribute:
			/* Reset to default */
			mForegroundTextColor	= nil
			mBackgroundTextColor	= nil
			mDoBold			= false
			mDoItalic		= false
			mDoUnderline		= false
			mDoReverse		= false
		case .requestScreenSize:
			/* Ack the size*/
			let ackcode: CNEscapeCode = .screenSize(self.currentColumnNumbers, self.currentRowNumbers)
			mInputPipe.fileHandleForWriting.write(string: ackcode.encode())
		default:
			let desc = code.description()
			NSLog("Unexpected code: \(desc)")
		}
	}

	/* Delegate of text view */
	#if os(OSX)
	public func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
		if let keybind = CNKeyBinding.decode(selectorName: commandSelector.description) {
			if let ecodes = keybind.toEscapeCode() {
				for ecode in ecodes {
					mInputPipe.fileHandleForWriting.write(string: ecode.encode())
				}
			}
		}
		return true // the command is processed in this method
	}
	#endif

	#if os(OSX)
	public func textView(_ textView: NSTextView, shouldChangeTextIn range: NSRange, replacementString: String?) -> Bool {
		if let str = replacementString {
			//NSLog("shouldChangeTextIn: \(range.description)")
			mInputPipe.fileHandleForWriting.write(string: str)
		}
		return false // reject this change
	}
	#else
	public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		//NSLog("shouldChangeTextIn: \(range.description)")
		mInputPipe.fileHandleForWriting.write(string: text)
		return false // reject this change
	}
	#endif

	public func setFontSize(pointSize size: CGFloat) {
		#if os(OSX)
			let newfont = NSFontManager.shared.convert(font, toSize: size)
			self.font   = newfont
		#else
			if let newfont = CNFont(name: self.font.fontName, size: size) {
				self.font   = newfont
			}
		#endif
	}

	public var currentColumnNumbers: Int {
		get {
			return mCurrentColumnNumbers
		}
		set(newnum){
			if let num = self.adjustColumnNumbers(number: newnum) {
				if self.mCurrentColumnNumbers != num {
					self.mCurrentColumnNumbers = num
					notify(viewControlEvent: .updateWindowSize)
				}
			}
		}
	}

	public var currentRowNumbers: Int {
		get {
			return mCurrentRowNumbers
		}
		set(newnum){
			if let num = self.adjustRowNumbers(number: newnum) {
				//NSLog("compare row num: \(self.mCurrentRowNumbers) <-> \(num)")
				if self.mCurrentRowNumbers != num {
					//NSLog("update row num: \(self.mCurrentRowNumbers) -> \(num)")
					self.mCurrentRowNumbers = num
					notify(viewControlEvent: .updateWindowSize)
				}
			}
		}
	}

	private func adjustColumnNumbers(number num: Int) -> Int? {
		if num >= MinimumColumnNumber {
			if let screensize = KCScreen.shared.contentSize {
				let fontsize  = fontSize()
				let maxnum    = Int(screensize.width / fontsize.width)
				//NSLog("ScreenSize = \(screensize.description), fontwidth=\(fontsize.width), num=\(num), maxnum=\(maxnum)")
				return min(maxnum, num)
			}
		}
		return nil
	}

	private func adjustRowNumbers(number num: Int) -> Int? {
		if num >= MinimumRowNumber {
			if let screensize = KCScreen.shared.contentSize {
				let fontsize   = fontSize()
				let maxnum     = Int(screensize.height / fontsize.height)
				//NSLog("ScreenSize = \(screensize.description) fontheight=\(fontsize.height), num=\(num), maxnum=\(maxnum)")
				return min(maxnum, num)
			}
		}
		return nil
	}

	public func verticalOffset() -> Int {
		#if os(OSX)
			if let layoutmgr = mTextView.layoutManager, let container = mTextView.textContainer, let storage = mTextView.textStorage {
				let visrange = layoutmgr.glyphRange(forBoundingRect: mTextView.visibleRect, in: container)
				let visindex = layoutmgr.characterIndexForGlyph(at: visrange.location)
				let str      = storage.string
				let idx      = str.startIndex
				let end      = str.index(idx, offsetBy: visindex)
				return storage.string.lineCount(from: idx, to: end)
			} else {
				return 0
			}
		#else
			let layoutmgr = mTextView.layoutManager
			let container = mTextView.textContainer
			let storage   = mTextView.textStorage

			let visrect   = CGRect(origin: mTextView.contentOffset, size: mTextView.frame.size)
			let visrange  = layoutmgr.glyphRange(forBoundingRect: visrect, in: container)
			let visindex  = layoutmgr.characterIndexForGlyph(at: visrange.location)
			let str       = storage.string
			let idx       = str.startIndex
			let end       = str.index(idx, offsetBy: visindex)
			return storage.string.lineCount(from: idx, to: end)
		#endif
	}

	public func fontSize() -> KCSize {
		let attr = [NSAttributedString.Key.font: mFont]
		let str: String = " "
		//NSLog("font size = \(str.size(withAttributes: attr).description)")
		return str.size(withAttributes: attr)
	}

	private func scrollToBottom(){
		#if os(OSX)
			mTextView.scrollToEndOfDocument(self)
		#else
			mTextView.selectedRange = NSRange(location: mTextView.text.count, length: 0)
			let scrollY = mTextView.contentSize.height - mTextView.bounds.height
			let scrollPoint = CGPoint(x: 0, y: scrollY > 0 ? scrollY : 0)
			mTextView.setContentOffset(scrollPoint, animated: true)
		#endif
	}

	open override var fittingSize: KCSize {
		get {
			let fontsize   = fontSize()
			let termsize   = KCSize(width:  fontsize.width  * CGFloat(mCurrentColumnNumbers),
						height: fontsize.height * CGFloat(mCurrentRowNumbers))
			//NSLog("fittingSize -> font:\(fontsize.width)x\(fontsize.height) size:\(mCurrentColumnNumbers)x\(mCurrentRowNumbers) -> \(termsize.description)")
			return termsize
		}
	}

	public override func setExpandability(holizontal holiz: KCViewBase.ExpansionPriority, vertical vert: KCViewBase.ExpansionPriority) {
		mTextView.setExpansionPriority(holizontal: holiz, vertical: vert)
		super.setExpandability(holizontal: holiz, vertical: vert)
	}

	open override func resize(_ size: KCSize) {
		//NSLog("resize <- \(size.description)")
		#if os(OSX)
			mTextView.setConstrainedFrameSize(size)
		#else
			mTextView.contentSize = size
		#endif
		super.resize(size)
	}

	public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if let key = keyPath, let vals = change {
			if let _ = vals[.newKey] as? Dictionary<CNInterfaceStyle, CNColor> {
				switch key {
				case CNPreference.shared.terminalPreference.ForegroundTextColorItem:
					self.updateForegroundColor()
				case CNPreference.shared.terminalPreference.BackgroundTextColorItem:
					self.updateBackgroundColor()
				default:
					NSLog("\(#file): Unknown key (2): \(key)")
				}
			} else if let font = vals[.newKey] as? CNFont {
				switch key {
				case CNPreference.shared.terminalPreference.FontItem:
					//NSLog("Change font: \(font.fontName)")
					self.font = font
				default:
					NSLog("\(#file): Unknown key (3): \(key)")
				}
			} else if let num = vals[.newKey] as? NSNumber {
				switch key {
				case CNPreference.shared.terminalPreference.ColumnNumberItem:
					self.currentColumnNumbers = num.intValue
					//NSLog("currentColumnNumbers = \(currentColumnNumbers)")
				case CNPreference.shared.terminalPreference.RowNumberItem:
					self.currentRowNumbers = num.intValue
				case CNPreference.shared.systemPreference.InterfaceStyleItem:
					self.updateForegroundColor()
					self.updateBackgroundColor()
				default:
					NSLog("\(#file): Unknown key (4): \(key)")
				}
			}
		}
	}

	private func updateForegroundColor() {
		let newcol = CNPreference.shared.terminalPreference.foregroundTextColor
		if let curcol = mTextView.textColor {
			textStorage.changeOverallTextColor(targetColor: curcol, newColor: newcol)
		}
		self.foregroundTextColor	= newcol
		#if os(OSX)
			mTextView.insertionPointColor	= newcol
		#endif
	}

	private func updateBackgroundColor() {
		let newcol = CNPreference.shared.terminalPreference.backgroundTextColor
		#if os(OSX)
			let curcol = mTextView.backgroundColor
			textStorage.changeOverallBackgroundColor(targetColor: curcol, newColor: newcol)
		#else
			if let curcol = mTextView.backgroundColor {
				textStorage.changeOverallBackgroundColor(targetColor: curcol, newColor: newcol)
			}
		#endif
		self.backgroundTextColor	= newcol
		mTextView.backgroundColor	= newcol
	}
}


