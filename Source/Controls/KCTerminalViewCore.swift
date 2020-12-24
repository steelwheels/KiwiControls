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

open class KCTerminalViewCore : KCView, KCTextViewDelegate, NSTextStorageDelegate
{
	public enum TerminalMode {
		case log
		case console
	}

	#if os(OSX)
	@IBOutlet weak var	mScrollView: NSScrollView!
	@IBOutlet weak var 	mTextView: NSTextView!
	#else
	@IBOutlet weak var mTextView: UITextView!
	#endif

	private var mInputPipe:			Pipe
	private var mOutputPipe:		Pipe
	private var mErrorPipe:			Pipe
	private var mCurrentIndex:		Int
	private var mSavedIndex:		Int
	private var mTerminalInfo:		CNTerminalInfo

	public override init(frame frameRect: KCRect) {
		let tpref = CNPreference.shared.terminalPreference

		mInputPipe	= Pipe()
		mOutputPipe	= Pipe()
		mErrorPipe	= Pipe()
		mCurrentIndex	= 0
		mSavedIndex	= 0
		mTerminalInfo	= CNTerminalInfo(width: tpref.width, height: tpref.height)
		mTerminalInfo.foregroundColor = tpref.foregroundTextColor
		mTerminalInfo.backgroundColor = tpref.backgroundTextColor
		super.init(frame: frameRect)
		setupObservers()
		setupFileStream()
	}

	public required init?(coder: NSCoder) {
		let tpref = CNPreference.shared.terminalPreference

		mInputPipe	= Pipe()
		mOutputPipe	= Pipe()
		mErrorPipe	= Pipe()
		mCurrentIndex	= 0
		mSavedIndex	= 0
		mTerminalInfo	= CNTerminalInfo(width: tpref.width, height: tpref.height)
		mTerminalInfo.foregroundColor = tpref.foregroundTextColor
		mTerminalInfo.backgroundColor = tpref.backgroundTextColor
		super.init(coder: coder)
		setupObservers()
		setupFileStream()
	}

	deinit {
		removeObservers()
	}

	private func setupObservers() {
		/* Start observe */
		let tpref = CNPreference.shared.terminalPreference
		tpref.addObserver(observer: self, forKey: tpref.WidthItem)
		tpref.addObserver(observer: self, forKey: tpref.HeightItem)
		tpref.addObserver(observer: self, forKey: tpref.ForegroundTextColorItem)
		tpref.addObserver(observer: self, forKey: tpref.BackgroundTextColorItem)
		tpref.addObserver(observer: self, forKey: tpref.FontItem)

		let spref = CNPreference.shared.systemPreference
		spref.addObserver(observer: self, forKey: CNSystemPreference.InterfaceStyleItem)
	}

	private func setupFileStream() {
		mOutputPipe.fileHandleForReading.readabilityHandler = {
			(_ hdl: FileHandle) -> Void in
			let data = hdl.availableData
			if let str = String.stringFromData(data: data) {
				CNExecuteInMainThread(doSync: false, execute: {
					() -> Void in
					self.receiveInputStream(string: str)
					self.scrollToBottom()
				})
			}
		}
		mErrorPipe.fileHandleForReading.readabilityHandler = {
			(_ hdl: FileHandle) -> Void in
			let data = hdl.availableData
			if let str = String.stringFromData(data: data) {
				CNExecuteInMainThread(doSync: false, execute: {
					self.receiveInputStream(string: str)
					self.scrollToBottom()
				})
			}
		}
	}

	private func removeObservers() {
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

	public func setup(mode md: TerminalMode, frame frm: CGRect)
	{
		let tpref = CNPreference.shared.terminalPreference

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

		/* Set mode */
		switch md {
		case .log:
			mTextView.isEditable			= false
			mTextView.isSelectable			= true
		case .console:
			mTextView.isEditable			= true
			mTextView.isSelectable			= true
		}

		/* Set font for this terminal */
		mTextView.font = tpref.font
		textStorage.changeOverallFont(font: tpref.font)

		/* Set colors */
		mTextView.textColor = tpref.foregroundTextColor
		#if os(OSX)
		mTextView.insertionPointColor = tpref.foregroundTextColor
		#endif
		mTextView.backgroundColor = tpref.backgroundTextColor

		/* Set delegate */
		mTextView.delegate = self
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

	private func receiveInputStream(string str: String) {
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
								font:			font,
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
	}

	public func leftTopOffset() -> Int {
		let lefttop = leftTopIndex()
		return textStorage.lineCount(from: 0, to: lefttop)
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

	public func setSelectedRange(range rng: NSRange){
		#if os(OSX)
			mTextView.setSelectedRange(rng)
		#else
			mTextView.selectedRange = rng
		#endif
	}

	private func executeCommandInView(escapeCode code: CNEscapeCode) {
		let tpref = CNPreference.shared.terminalPreference
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
			mTerminalInfo.foregroundColor	= fcol
		case .defaultForegroundColor:
			mTerminalInfo.foregroundColor	= tpref.foregroundTextColor
		case .backgroundColor(let bcol):
			mTerminalInfo.backgroundColor	= bcol
		case .defaultBackgroundColor:
			mTerminalInfo.backgroundColor	= tpref.backgroundTextColor
		case .resetCharacterAttribute:
			/* Reset to default */
			mTerminalInfo.foregroundColor	= tpref.foregroundTextColor
			mTerminalInfo.backgroundColor	= tpref.backgroundTextColor
			mTerminalInfo.doBold		= false
			mTerminalInfo.doItalic		= false
			mTerminalInfo.doUnderLine	= false
			mTerminalInfo.doReverse		= false
			updateForegroundColor()
			updateBackgroundColor()
		case .requestScreenSize:
			/* Ack the size*/
			let ackcode: CNEscapeCode = .screenSize(self.width, self.height)
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
	
	public var width: Int {
		get { return mTerminalInfo.width }
	}

	public var height: Int {
		get { return mTerminalInfo.height }
	}

	public var foregroundTextColor: CNColor {
		get { return mTerminalInfo.foregroundColor }
	}

	public var backgroundTextColor: CNColor {
		get { return mTerminalInfo.backgroundColor }
	}

	public var font: CNFont {
		get { return CNPreference.shared.terminalPreference.font	}
	}

	public override var intrinsicContentSize: KCSize {
		get {
			let result = targetSize()
			NSLog("KCTerminalViewCore intrinsic: \(result.description)")
			return result
		}
	}

	public override func setFrameSize(_ newsize: KCSize) {
		//NSLog("NSTerminalViewCore: setFrameSize \(newsize.description)")
		setCoreFrameSize(core: mTextView,   size: newsize)
		#if os(OSX)
			setCoreFrameSize(core: mScrollView, size: newsize)
		#endif
		super.setFrameSize(newsize)
		/* Update terminal size info */
		updateTerminalSize()
	}

	public override func setExpandability(holizontal holiz: KCViewBase.ExpansionPriority, vertical vert: KCViewBase.ExpansionPriority) {
		mTextView.setExpansionPriority(holizontal: holiz, vertical: vert)
		super.setExpandability(holizontal: holiz, vertical: vert)
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

	private func updateTerminalSize() {
		let viewsize	= mTextView.frame.size
		let fontsize	= fontSize()
		let barwidth	= scrollerWidth()
		let newwidth	= Int((viewsize.width - barwidth) / fontsize.width)
		let newheight   = Int(viewsize.height / fontsize.height)
		//NSLog("updateTerminalInfo: \(newwidth) \(newheight)")

		var doinvalidate = false
		if mTerminalInfo.width != newwidth {
			mTerminalInfo.width	= newwidth
			doinvalidate		= true
		}
		if mTerminalInfo.height != newheight {
			mTerminalInfo.height	= newheight
			doinvalidate		= true
		}
		if doinvalidate {
			mTextView.invalidateIntrinsicContentSize()
		}
	}

	public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		CNExecuteInMainThread(doSync: false, execute: { [self]
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
						NSLog("Change font: \(font.fontName)")
						self.updateFont()
						self.notify(viewControlEvent: .updateWindowSize)
					default:
						NSLog("\(#file): Unknown key (3): \(key)")
					}
				} else if let _ = vals[.newKey] as? NSNumber {
					switch key {
					case CNPreference.shared.terminalPreference.WidthItem:
						let newwidth = CNPreference.shared.terminalPreference.width
						if mTerminalInfo.width != newwidth {
							mTextView.invalidateIntrinsicContentSize()
							mTextView.setNeedsLayout()
							self.notify(viewControlEvent: .updateWindowSize)
						}
					case CNPreference.shared.terminalPreference.HeightItem:
						let newheight = CNPreference.shared.terminalPreference.height
						if mTerminalInfo.height != newheight {
							mTextView.invalidateIntrinsicContentSize()
							mTextView.setNeedsLayout()
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
		mTextView.invalidateIntrinsicContentSize()
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

	private func fontSize() -> KCSize {
		let attr = [NSAttributedString.Key.font: self.font]
		let str: String = " "
		return str.size(withAttributes: attr)
	}

	private func scrollerWidth() -> CGFloat {
		#if os(OSX)
			let barwidth: CGFloat = NSScroller.scrollerWidth(for: .regular, scrollerStyle: .overlay)
		#else
			let barwidth: CGFloat = 0.0
		#endif
		return barwidth
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
}

