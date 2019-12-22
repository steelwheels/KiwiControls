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
	private var mCurrentIndex:		Int = 0
	private var mMinimumColumnNumbers:	Int = 10
	private var mMinimumLineNumbers:	Int = 1
	private var mTerminalInfo:		CNTerminalInfo

	public var inputFileHandle: FileHandle {
		get { return mInputPipe.fileHandleForReading }
	}

	public var outputFileHandle: FileHandle {
		get { return mOutputPipe.fileHandleForWriting }
	}

	public var errorFileHandle: FileHandle {
		get { return mErrorPipe.fileHandleForWriting }
	}

	public override init(frame frameRect: KCRect) {
		mInputPipe	= Pipe()
		mOutputPipe	= Pipe()
		mErrorPipe	= Pipe()
		mTerminalInfo	= CNTerminalInfo()
		super.init(frame: frameRect)
	}

	public required init?(coder: NSCoder) {
		mInputPipe	= Pipe()
		mOutputPipe	= Pipe()
		mErrorPipe	= Pipe()
		mTerminalInfo	= CNTerminalInfo()
		super.init(coder: coder)
	}

	deinit {
		mOutputPipe.fileHandleForReading.readabilityHandler = nil
		mErrorPipe.fileHandleForReading.readabilityHandler  = nil
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

	public func setup(mode md: TerminalMode, frame frm: CGRect)
	{
		#if os(OSX)
			mTextView.font = NSFont.systemFont(ofSize: 10.0)
			mTextView.drawsBackground = true
		#else
			mTextView.font = UIFont.systemFont(ofSize: 10.0)
			//mTextView.drawsBackground     = true
		#endif
		mTextView.translatesAutoresizingMaskIntoConstraints = true // Keep true to scrollable
		mTextView.autoresizesSubviews = true
		mTextView.backgroundColor     = KCColor.black

		#if os(OSX)
			mTextView.isVerticallyResizable   = true
			mTextView.isHorizontallyResizable = false
			mTextView.insertionPointColor	  = KCColor.green
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
	}

	private func receiveInputStream(inputData data: Data) {
		if let str = String(data: data, encoding: .utf8) {
			switch CNEscapeCode.decode(string: str) {
			case .ok(let codes):
				let storage = textStorage
				storage.beginEditing()
				for code in codes {
					if let newidx = storage.execute(index: mCurrentIndex, terminalInfo: mTerminalInfo, escapeCode: code) {
						mCurrentIndex = newidx
					} else {
						executeCommandInView(escapeCode: code)
					}
				}
				storage.endEditing()
			case .error(let err):
				NSLog("Failed to decode escape code: \(err.description())")
			}
		} else {
			NSLog("Failed to decode data: \(data)")
		}
	}

	private func executeCommandInView(escapeCode code: CNEscapeCode){
		switch code {
		case .scrollUp:
			break
		case .scrollDown:
			break
		case .foregroundColor(let fcol):
			mTerminalInfo.foregroundColor = fcol
		case .backgroundColor(let bcol):
			mTerminalInfo.backgroundColor = bcol
		case .setNormalAttributes:
			/* Reset to default */
			let pref = CNPreference.shared.terminalPreference
			mTerminalInfo.foregroundColor  = pref.foregroundColor
			mTerminalInfo.backgroundColor  = pref.backgroundColor
		case .requestScreenSize:
			/* Ack the size*/
			let ackcode: CNEscapeCode = .screenSize(self.columnNumbers, self.lineNumbers)
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

	public var columnNumbers: Int {
		get { return Int(self.bounds.width / fontSize().width) }
	}

	public var lineNumbers: Int {
		get { return Int(self.bounds.height / fontSize().height) }
	}

	public var minimumColumnNumbers: Int {
		get { return mMinimumColumnNumbers }
		set(newnum){ mMinimumColumnNumbers = newnum }
	}

	public var minimumLineNumbers: Int {
		get { return mMinimumLineNumbers }
		set(newnum){ mMinimumLineNumbers = newnum }
	}

	public func fontSize() -> KCSize {
		let size: KCSize
		#if os(OSX)
			if let font = mTextView.font {
				size = font.boundingRectForFont.size
			} else {
				size = KCSize(width: 10.0, height: 10.0)
			}
		#else
			if let font = mTextView.font {
				size = KCSize(width: font.lineHeight, height: font.pointSize)
			} else {
				size = KCSize(width: 10.0, height: 10.0)
			}
		#endif
		return size
	}

	private var insertionPosition: Int {
		get {
			#if os(OSX)
				let values = mTextView.selectedRanges
				for value in values {
					let range = value.rangeValue
					if range.length == 0 {
						return range.location
					}
				}
				NSLog("Error: No insertion point")
				return 0
			#else
				return mTextView.selectedRange.location
			#endif
		}
		set(newpt){
			let range = NSRange(location: newpt, length: 0)
			#if os(OSX)
				mTextView.setSelectedRange(range)
			#else
				mTextView.selectedRange = range
			#endif
		}
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

	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		let minsize = minimumSize(size)
		let result  = KCSize(width:  max(size.width,  minsize.width),
				     height: max(size.height, minsize.height))
		return result
	}

	open override func resize(_ size: KCSize) {
		mTextView.frame.size  = size
		mTextView.bounds.size = size
		super.resize(size)
	}

	open override func minimumSize(_ size: CGSize) -> CGSize {
		let fontsize  = fontSize()
		let reqwidth  = KCScreen.shared.pointToPixel(point: fontsize.width  * CGFloat(minimumColumnNumbers))
		let reqheight = KCScreen.shared.pointToPixel(point: fontsize.height * CGFloat(minimumLineNumbers))
		let reqsize   = KCSize(width: reqwidth, height: reqheight)
		return reqsize
	}
}


