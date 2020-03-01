/**
 * @file	KCTextViewCore.swift
 * @brief Define KCTextViewCore class
 * @par Copyright
 *   Copyright (C) 2017, 2018, 2019 Steel Wheels Project
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
	private var mTextTerminalColor:		CNColor
	private var mBackgroundTerminalColor:	CNColor
	private var mFont:			CNFont
	private var mCurrentColumnNumbers:	Int
	private var mCurrentRowNumbers:		Int

	public override init(frame frameRect: KCRect) {
		mInputPipe			= Pipe()
		mOutputPipe			= Pipe()
		mErrorPipe			= Pipe()
		mCurrentIndex			= 0
		mTextTerminalColor		= CNColor.Green
		mBackgroundTerminalColor	= CNColor.Black
		mFont				= CNFont.systemFont(ofSize: CNFont.systemFontSize)
		mCurrentColumnNumbers		= 80
		mCurrentRowNumbers		= 25
		super.init(frame: frameRect)
	}

	public required init?(coder: NSCoder) {
		mInputPipe			= Pipe()
		mOutputPipe			= Pipe()
		mErrorPipe			= Pipe()
		mCurrentIndex			= 0
		mTextTerminalColor		= CNColor.Green
		mBackgroundTerminalColor	= CNColor.Black
		mFont				= CNFont.systemFont(ofSize: CNFont.systemFontSize)
		mCurrentColumnNumbers		= 80
		mCurrentRowNumbers		= 25
		super.init(coder: coder)
	}

	deinit {
		mOutputPipe.fileHandleForReading.readabilityHandler = nil
		mErrorPipe.fileHandleForReading.readabilityHandler  = nil

		/* Stop to observe */
		let pref = CNPreference.shared.terminalPreference
		pref.removeObserver(observer: self, forKey: pref.columnNumberItem)
		pref.removeObserver(observer: self, forKey: pref.rowNumberItem)
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

	public var foregroundTextColor: KCColor? {
		get { return mTextView.textColor }
		set(newcol)	{
			if let col = newcol {
				mTextView.textColor = col
				#if os(OSX)
					mTextView.insertionPointColor = col
				#endif
				mTextTerminalColor = col.toTerminalColor()
			}
		}
	}

	public var backgroundTextColor: KCColor? {
		get 		{ return mTextView.backgroundColor   }
		set(newcol)	{
			if let col = newcol {
				mTextView.backgroundColor = col
				let newcol = col.toTerminalColor()
				if !mBackgroundTerminalColor.isEqual(to: newcol) {
					textStorage.changeOverallBackgroundColor(targetColor: mBackgroundTerminalColor.toObject(), newColor: newcol.toObject())
					mBackgroundTerminalColor = newcol
				}
			}
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
		if let font = pref.font {
			self.font = font
		} else {
			self.font = CNFont.monospacedDigitSystemFont(ofSize: 16.0, weight: .regular)
		}

		if let num = pref.columnNumber {
			self.mCurrentColumnNumbers = num
		}
		if let num = pref.rowNumber {
			self.mCurrentRowNumbers = num
		}

		self.foregroundTextColor       	= pref.foregroundTextColor
		self.backgroundTextColor 	= pref.backgroundTextColor

		#if os(OSX)
			mTextView.drawsBackground	  = true
			mTextView.isVerticallyResizable   = true
			mTextView.isHorizontallyResizable = true
			if let color = pref.foregroundTextColor {
				mTextView.insertionPointColor	  = color
			}
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
		pref.addObserver(observer: self, forKey: pref.columnNumberItem)
		pref.addObserver(observer: self, forKey: pref.rowNumberItem)
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

	private func receiveInputStream(inputData data: Data) {
		if let str = String(data: data, encoding: .utf8) {
			switch CNEscapeCode.decode(string: str) {
			case .ok(let codes):
				let storage = textStorage
				storage.beginEditing()
				for code in codes {
					if let newidx = storage.execute(index:		 mCurrentIndex,
									foregroundColor: mTextTerminalColor,
									backgroundColor: mBackgroundTerminalColor,
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
			self.foregroundTextColor = fcol.toObject()
		case .backgroundColor(let bcol):
			self.backgroundTextColor = bcol.toObject()
		case .setNormalAttributes:
			/* Reset to default */
			let pref = CNPreference.shared.terminalPreference
			self.foregroundTextColor = pref.foregroundTextColor
			self.backgroundTextColor = pref.backgroundTextColor
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
				//NSLog("compare column num: \(self.mCurrentColumnNumbers) <-> \(num)")
				if self.mCurrentColumnNumbers != num {
					NSLog("set column num: \(self.mCurrentColumnNumbers) -> \(num)")
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
					NSLog("set row num: \(self.mCurrentRowNumbers) -> \(num)")
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
		let astr = NSAttributedString(string: " ", attributes: attr)
		return astr.size()
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
			let fontsize  = fontSize()
			let termsize  = KCSize(width:  fontsize.width  * CGFloat(mCurrentColumnNumbers),
					       height: fontsize.height * CGFloat(mCurrentRowNumbers))
			//NSLog("fittingSize -> font:\(fontsize.width)x\(fontsize.height) size:\(mCurrentColumnNumbers)x\(mCurrentRowNumbers) -> \(termsize.description)")
			return termsize
		}
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
			if let color = vals[.newKey] as? KCColor {
				switch key {
				case CNPreference.shared.terminalPreference.ForegroundTextColorItem:
					//NSLog("Change foreground color")
					self.foregroundTextColor = color
				case CNPreference.shared.terminalPreference.BackgroundTextColorItem:
					//NSLog("Change background color")
					self.backgroundTextColor = color
				default:
					break
				}
			} else if let font = vals[.newKey] as? CNFont {
				switch key {
				case CNPreference.shared.terminalPreference.FontItem:
					//NSLog("Change font: \(font.fontName)")
					self.font = font
				default:
					break
				}
			} else if let num = vals[.newKey] as? NSNumber {
				switch key {
				case CNPreference.shared.terminalPreference.columnNumberItem:
					self.currentColumnNumbers = num.intValue
				case CNPreference.shared.terminalPreference.rowNumberItem:
					self.currentRowNumbers = num.intValue
				default:
					break
				}
			}
		}
	}
}


