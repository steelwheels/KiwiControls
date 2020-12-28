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
	private let MinimumWidth		= 10
	private let MinimumHeight		= 10

	public enum TerminalMode {
		case log
		case console
	}

	#if os(OSX)
	@IBOutlet var		mTextView: NSTextView!
	@IBOutlet weak var	mScrollView: NSScrollView!
	#else
	@IBOutlet weak var mTextView: UITextView!
	#endif

	private var mInputPipe:			Pipe
	private var mOutputPipe:		Pipe
	private var mErrorPipe:			Pipe
	private var mCurrentIndex:		Int
	private var mSavedIndex:		Int
	private var mForegroundTextColor:	CNColor?
	private var mBackgroundTextColor:	CNColor?
	private var mFont:			CNFont
	private var mTerminalInfo:		CNTerminalInfo

	public override init(frame frameRect: KCRect) {
		let tpref = CNPreference.shared.terminalPreference
		mInputPipe			= Pipe()
		mOutputPipe			= Pipe()
		mErrorPipe			= Pipe()
		mCurrentIndex			= 0
		mSavedIndex			= 0
		mForegroundTextColor		= nil
		mBackgroundTextColor		= nil
		mFont				= CNFont.systemFont(ofSize: CNFont.systemFontSize)
		mTerminalInfo			= CNTerminalInfo(width: tpref.width, height: tpref.height)
		super.init(frame: frameRect)
	}

	public required init?(coder: NSCoder) {
		let tpref = CNPreference.shared.terminalPreference
		mInputPipe			= Pipe()
		mOutputPipe			= Pipe()
		mErrorPipe			= Pipe()
		mCurrentIndex			= 0
		mSavedIndex			= 0
		mForegroundTextColor		= nil
		mBackgroundTextColor		= nil
		mFont				= CNFont.systemFont(ofSize: CNFont.systemFontSize)
		mTerminalInfo			= CNTerminalInfo(width: tpref.width, height: tpref.height)
		super.init(coder: coder)
	}

	deinit {
		mOutputPipe.fileHandleForReading.readabilityHandler = nil
		mErrorPipe.fileHandleForReading.readabilityHandler  = nil

		/* Stop to observe */
		let pref = CNPreference.shared.terminalPreference
		pref.removeObserver(observer: self, forKey: pref.WidthItem)
		pref.removeObserver(observer: self, forKey: pref.HeightItem)
		pref.removeObserver(observer: self, forKey: pref.ForegroundTextColorItem)
		pref.removeObserver(observer: self, forKey: pref.BackgroundTextColorItem)
		pref.removeObserver(observer: self, forKey: pref.FontItem)

		let syspref = CNPreference.shared.systemPreference
		syspref.removeObserver(observer: self, forKey: CNSystemPreference.InterfaceStyleItem)
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
		self.mTerminalInfo.width		= pref.width
		self.mTerminalInfo.height		= pref.height

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
			mTextView.isSelectable			= true
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
		mCurrentIndex    = 0

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
		pref.addObserver(observer: self, forKey: pref.WidthItem)
		pref.addObserver(observer: self, forKey: pref.HeightItem)
		pref.addObserver(observer: self, forKey: pref.ForegroundTextColorItem)
		pref.addObserver(observer: self, forKey: pref.BackgroundTextColorItem)
		pref.addObserver(observer: self, forKey: pref.FontItem)

		let syspref = CNPreference.shared.systemPreference
		syspref.addObserver(observer: self, forKey: CNSystemPreference.InterfaceStyleItem)
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
		if let str = String.stringFromData(data: data) {
			switch CNEscapeCode.decode(string: str) {
			case .ok(let codes):
				let storage = self.textStorage
				var curidx  = mCurrentIndex
				for code in codes {
					mTerminalInfo.foregroundColor = foregroundTextColor
					mTerminalInfo.backgroundColor = backgroundTextColor
					let base = leftTopOffset()
					if let newidx = storage.execute(base:			base,
									index:			curidx,
									font:			mFont,
									terminalInfo: 		mTerminalInfo,
									escapeCode: code) {
						curidx = newidx
					} else {
						executeCommandInView(escapeCode: code)
					}
				}
				/* Update selected range */
				let range   = NSRange(location: curidx, length: 0)
				setSelectedRange(range: range)
				mCurrentIndex = curidx
			case .error(let err):
				NSLog("Failed to decode escape code: \(err.description())")
			@unknown default:
				NSLog("Failed to decode escape code: <unknown>")
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

	private func executeCommandInView(escapeCode code: CNEscapeCode) {
		switch code {
		case .boldCharacter(let flag):
			mTerminalInfo.doBold = flag
		case .underlineCharacter(let flag):
			mTerminalInfo.doUnderLine = flag
		case .blinkCharacter(let flag):
			NSLog("Blink character setting is ignored: \(flag)")
		case .reverseCharacter(let flag):
			mTerminalInfo.doReverse = flag
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
			mForegroundTextColor		= nil
			mBackgroundTextColor		= nil
			mTerminalInfo.doBold		= false
			mTerminalInfo.doItalic		= false
			mTerminalInfo.doUnderLine	= false
			mTerminalInfo.doReverse		= false
		case .requestScreenSize:
			/* Ack the size*/
			let ackcode: CNEscapeCode = .screenSize(self.currentWidth, self.currentHeight)
			mInputPipe.fileHandleForWriting.write(string: ackcode.encode())
		case .saveCursorPosition:
			mSavedIndex = mCurrentIndex
		case .restoreCursorPosition:
			let str = self.textStorage.string
			let endidx  = str.distance(from: str.startIndex, to: str.endIndex)
			mCurrentIndex = min(mSavedIndex, endidx)
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

	public var currentWidth: Int {
		get { return mTerminalInfo.width }
	}

	public var currentHeight: Int {
		get { return mTerminalInfo.height }
	}

	private func leftTopIndex() -> Int {
		#if os(OSX)
			if let layoutmgr = mTextView.layoutManager, let container = mTextView.textContainer {
				let visrange = layoutmgr.glyphRange(forBoundingRect: mTextView.visibleRect, in: container)
				let visindex = layoutmgr.characterIndexForGlyph(at: visrange.location)
				return visindex
			} else {
				return 0
			}
		#else
			let layoutmgr = mTextView.layoutManager
			let container = mTextView.textContainer

			let visrect   = CGRect(origin: mTextView.contentOffset, size: mTextView.frame.size)
			let visrange  = layoutmgr.glyphRange(forBoundingRect: visrect, in: container)
			let visindex  = layoutmgr.characterIndexForGlyph(at: visrange.location)
			return visindex
		#endif
	}

	public func leftTopOffset() -> Int {
		let lefttop = leftTopIndex()
		return textStorage.lineCount(from: 0, to: lefttop)
	}

	public func fontSize() -> KCSize {
		let attr = [NSAttributedString.Key.font: mFont]
		let str: String = " "
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

	open override func setFrameSize(_ newsize: KCSize) {
		super.setFrameSize(newsize)
		#if os(OSX)
			mTextView.setFrameSize(newsize)
			mScrollView.setFrameSize(newsize)
		#else
			mTextView.setFrameSize(size: newsize)
		#endif
	}

	open override var intrinsicContentSize: KCSize {
		get { return targetSize() }
	}

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		#if os(OSX)
			mTextView.invalidateIntrinsicContentSize()
			mScrollView.invalidateIntrinsicContentSize()
		#else
			mTextView.invalidateIntrinsicContentSize()
		#endif
	}

	private func targetSize() -> KCSize {
		let tpref      = CNPreference.shared.terminalPreference
		let fontsize   = fontSize()
		let termwidth  = CGFloat(tpref.width)  * fontsize.width
		let termheight = CGFloat(tpref.height) * fontsize.height
		let barwidth   = scrollerWidth()
		let termsize   = KCSize(width: termwidth + barwidth, height: termheight)
		return termsize
	}

	private func scrollerWidth() -> CGFloat {
		#if os(OSX)
			let barwidth: CGFloat = NSScroller.scrollerWidth(for: .regular, scrollerStyle: .overlay)
		#else
			let barwidth: CGFloat = 0.0
		#endif
		return barwidth
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
					case CNPreference.shared.terminalPreference.WidthItem:
						if self.currentWidth != num.intValue {
							NSLog("Update terminal width:  \(self.currentWidth) -> \(num) at \(#function)")
							/* Update terminal size */
							self.mTerminalInfo.width = num.intValue
							NSLog("observeValue: \(self.mTerminalInfo.width) \(self.mTerminalInfo.height)")
							self.notify(viewControlEvent: .updateWindowSize)
						}
					case CNPreference.shared.terminalPreference.HeightItem:
						if self.currentHeight != num.intValue {
							NSLog("Update terminal height:  \(self.currentHeight) -> \(num) at \(#function)")
							/* Update terminal size */
							self.mTerminalInfo.height = num.intValue
							NSLog("observeValue: \(self.mTerminalInfo.width) \(self.mTerminalInfo.height)")
							self.notify(viewControlEvent: .updateWindowSize)
						}
					case CNSystemPreference.InterfaceStyleItem:
						self.updateForegroundColor()
						self.updateBackgroundColor()
					default:
						NSLog("\(#file): Unknown key (4): \(key)")
					}
				}
			}
		})
	}

	private func updateForegroundColor() {
		let newcol  = CNPreference.shared.terminalPreference.foregroundTextColor
		let storage = self.textStorage
		if let curcol = mTextView.textColor {
			storage.changeOverallTextColor(targetColor: curcol, newColor: newcol)
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
			let storage = self.textStorage
			storage.changeOverallBackgroundColor(targetColor: curcol, newColor: newcol)
		#else
			if let curcol = mTextView.backgroundColor {
				let storage = self.textStorage
				storage.changeOverallBackgroundColor(targetColor: curcol, newColor: newcol)
			}
		#endif
		self.backgroundTextColor	= newcol
		mTextView.backgroundColor	= newcol
	}
}


