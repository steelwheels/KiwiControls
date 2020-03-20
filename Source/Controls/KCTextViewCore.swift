/**
 * @file	KCTextViewCore.swift
 * @brief Define KCTextViewCore class
 * @par Copyright
 *   Copyright (C) 2017-2022 Steel Wheels Project
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
	private var mCurrentIndex:		Int
	private var mForegroundTextColor:	CNColor?
	private var mBackgroundTextColor:	CNColor?
	private var mFont:			CNFont
	private var mCurrentColumnNumbers:	Int
	private var mCurrentRowNumbers:		Int

	public override init(frame frameRect: KCRect) {
		mInputPipe			= Pipe()
		mOutputPipe			= Pipe()
		mErrorPipe			= Pipe()
		mCurrentIndex			= 0
		mForegroundTextColor		= nil
		mBackgroundTextColor		= nil
		mFont				= CNFont.systemFont(ofSize: CNFont.systemFontSize)
		mCurrentColumnNumbers		= 10
		mCurrentRowNumbers		= 10
		super.init(frame: frameRect)
	}

	public required init?(coder: NSCoder) {
		mInputPipe			= Pipe()
		mOutputPipe			= Pipe()
		mErrorPipe			= Pipe()
		mCurrentIndex			= 0
		mForegroundTextColor		= nil
		mBackgroundTextColor		= nil
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
		get 		{
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

	private func updateDefaultForegroundColor(color col: CNColor) {
		textStorage.changeOverallTextColor(targetColor: foregroundTextColor, newColor: col)
	}

	private func updateDefaultBackgroundColor(color col: CNColor) {
		textStorage.changeOverallBackgroundColor(targetColor: backgroundTextColor, newColor: col)
		mTextView.backgroundColor = col
	}

	private func receiveInputStream(inputData data: Data) {
		if let str = String(data: data, encoding: .utf8) {
			switch CNEscapeCode.decode(string: str) {
			case .ok(let codes):
				let storage = textStorage
				storage.beginEditing()
				for code in codes {
					if let newidx = storage.execute(index:		 mCurrentIndex,
									foregroundColor: foregroundTextColor,
									backgroundColor: mBackgroundTextColor,
									font: 		 mFont,
									escapeCode: code) {
						mCurrentIndex = newidx
					} else {
						executeCommandInView(escapeCode: code)
					}
				}
				storage.endEditing()
				/* Update selected range */
				let range = NSRange(location: mCurrentIndex, length: 0)
				setSelectedRange(range: range)
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
		case .foregroundColor(let fcol):
			self.foregroundTextColor = fcol
		case .backgroundColor(let bcol):
			self.backgroundTextColor = bcol
		case .setNormalAttributes:
			/* Reset to default */
			mForegroundTextColor = nil
			mBackgroundTextColor = nil
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
			if let color = vals[.newKey] as? CNColor {
				switch key {
				case CNPreference.shared.terminalPreference.ForegroundTextColorItem:
					//NSLog("Change foreground color")
					updateDefaultForegroundColor(color: color)
					self.foregroundTextColor = color
				case CNPreference.shared.terminalPreference.BackgroundTextColorItem:
					//NSLog("Change background color")
					updateDefaultBackgroundColor(color: color)
					self.backgroundTextColor = color
				default:
					NSLog("Unknown key (1): \(key)")
				}
			} else if let font = vals[.newKey] as? CNFont {
				switch key {
				case CNPreference.shared.terminalPreference.FontItem:
					//NSLog("Change font: \(font.fontName)")
					self.font = font
				default:
					NSLog("Unknown key (2): \(key)")
				}
			} else if let num = vals[.newKey] as? NSNumber {
				switch key {
				case CNPreference.shared.terminalPreference.ColumnNumberItem:
					self.currentColumnNumbers = num.intValue
					//NSLog("currentColumnNumbers = \(currentColumnNumbers)")
				case CNPreference.shared.terminalPreference.RowNumberItem:
					self.currentRowNumbers = num.intValue
					//NSLog("currentRowNumbers = \(currentRowNumbers)")
				default:
					NSLog("Unknown key (3): \(key)")
				}
			}
		}
	}
}


