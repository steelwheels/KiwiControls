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
	public typealias TerminalMode = KCStorageController.TerminalMode

	#if os(OSX)
		@IBOutlet var mTextView: NSTextView!
	#else
		@IBOutlet weak var mTextView: UITextView!
	#endif

	private var mInputPipe:			Pipe
	private var mOutputPipe:		Pipe
	private var mErrorPipe:			Pipe
	private var mStorageController:		KCStorageController?  = nil
	private var mTerminalDelegate:		KCTerminalDelegate? = nil
	private var mMinimumColumnNumbers:	Int = 10
	private var mMinimumLineNumbers:	Int = 1

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
		super.init(frame: frameRect)
	}

	public required init?(coder: NSCoder) {
		mInputPipe	= Pipe()
		mOutputPipe	= Pipe()
		mErrorPipe	= Pipe()
		super.init(coder: coder)
	}

	deinit {
		mOutputPipe.fileHandleForReading.readabilityHandler = nil
		mErrorPipe.fileHandleForReading.readabilityHandler  = nil
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

		/* Allocate delegate */
		let delegate = KCTerminalDelegate()
		delegate.pressNewline = {
			() -> Void in
			self.pressNewline()
		}
		delegate.pressTab = {
			() -> Void in
			self.pressTab()
		}
		mTerminalDelegate = delegate
	
		mStorageController  = KCStorageController(mode: md, delegate: delegate)

		mOutputPipe.fileHandleForReading.readabilityHandler = {
			[weak self]  (_ hdl: FileHandle) -> Void in
			if let myself = self {
				let data = hdl.availableData
				CNExecuteInMainThread(doSync: false, execute: {
					() -> Void in
					#if os(OSX)
						if let controller = myself.mStorageController, let storage = myself.mTextView.textStorage {
							controller.receive(textStorage: storage, type: .normal, data: data)
							myself.insertionPosition = controller.insertionPosition
							//NSLog("IP = \(myself.insertionPosition)")
						}
					#else
						if let controller = myself.mStorageController {
							let storage = myself.mTextView.textStorage
							controller.receive(textStorage: storage, type: .normal, data: data)
							myself.insertionPosition = controller.insertionPosition
							//NSLog("IP = \(myself.insertionPosition)")
						}
					#endif
					myself.scrollToBottom()
				})
			}
		}
		mErrorPipe.fileHandleForReading.readabilityHandler = {
			[weak self]  (_ hdl: FileHandle) -> Void in
			if let myself = self {
				let data = hdl.availableData
				CNExecuteInMainThread(doSync: false, execute: {
					#if os(OSX)
						if let controller = myself.mStorageController, let storage = myself.mTextView.textStorage {
							controller.receive(textStorage: storage, type: .error, data: data)
						}
					#else
						if let controller = myself.mStorageController {
							let storage = myself.mTextView.textStorage
							controller.receive(textStorage: storage, type: .error, data: data)
						}
					#endif
					myself.scrollToBottom()
				})
			}
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
			mInputPipe.fileHandleForWriting.write(string: str)
		}
		return false // reject this change
	}
	#else
	public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
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

	public var color: KCTextColor {
		get { return storageController.color }
		set(newcol){ storageController.color = newcol }
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

	private var storageController: KCStorageController {
		get {
			if let controller = mStorageController {
				return controller
			} else {
				fatalError("Can not happen")
			}
		}
	}

	open func pressNewline() {
	}

	open func pressTab() {
	}
}

/*
open class KCTextViewCore : KCView, KCTextViewDelegate
{
	public static let INSERTION_POINT	= -1

	public enum TextViewType {
		case	console
		case	terminal
	}



	private var mViewType:			TextViewType = .console
	private var mTerminalStorage:		KCTerminalStorage? = nil


	public func setup(type typ: TextViewType, frame frm: CGRect, output outhdl: FileHandle?) {
		updateAttributes()
		self.rebounds(origin: KCPoint.zero, size: frm.size)

		switch typ {
		case .console:
			mTextViewDelegates = KCConsoleViewDelegates(coreView: self)
		case .terminal:
			if let hdl = outhdl {
				mTextViewDelegates = KCTerminalViewDelegates(coreView: self, output: hdl)
			} else {
				NSLog("Failed to convert interface")
			}
		}
		mTextView.delegate            = mTextViewDelegates!
		textStorage.delegate          = mTextViewDelegates!
	}

	public var viewType: TextViewType { get { return mViewType }}

	public var textViewDelegate: KCTextViewDelegates? {
		get { return mTextViewDelegates }
	}

	public var textStorage: NSTextStorage {
		get {
			#if os(OSX)
				if let storage = mTextView.textStorage {
					return storage
				} else {
					fatalError("No storage")
				}
			#else
				return mTextView.textStorage
			#endif

		}
	}



	public func updateAttributes(){
		if let font = mTextView.font {
			mNormalAttributes = [
				.font: 			font,
				.foregroundColor:	mColor.normalColor,
				.backgroundColor:	mColor.backgroundColor
			]
			mErrorAttributes = [
				.font: 			font,
				.foregroundColor:	mColor.errorColor,
				.backgroundColor:	mColor.backgroundColor
			]
		} else {
			NSLog("Failed to load font")
		}
	}

	public func selectedRanges() -> Array<NSRange> {
		var result: Array<NSRange> = []
		#if os(OSX)
			let ranges = mTextView.selectedRanges
			for src in ranges {
				result.append(src.rangeValue)
			}
		#else
			let range  = mTextView.selectedRange
			result.append(range)
		#endif
		return result
	}



	public func appendText(normal str: String){
		let astr = NSAttributedString(string: str, attributes: mNormalAttributes)
		appendAttributedText(string: astr)
	}

	public func appendText(error str: String){
		let astr = NSAttributedString(string: str, attributes: mErrorAttributes)
		appendAttributedText(string: astr)
	}

	private func appendAttributedText(string str: NSAttributedString){
		CNExecuteInMainThread(doSync: false, execute: {
			[weak self] () -> Void in
			if let myself = self {
				myself.syncAppend(destinationStorage: myself.textStorage, string: str)
				myself.scrollToBottom()
			}
		})
	}

	private func syncAppend(destinationStorage storage: NSTextStorage, string str: NSAttributedString){
		storage.beginEditing()
		storage.append(str)
		storage.endEditing()
	}

	public func insertText(normal str: String, before pos: Int){
		let astr = NSAttributedString(string: str, attributes: mNormalAttributes)
		insertAttributedText(string: astr, before: pos)
	}

	public func insertText(error str: String, before pos: Int){
		let astr = NSAttributedString(string: str, attributes: mErrorAttributes)
		insertAttributedText(string: astr, before: pos)
	}

	private func insertAttributedText(string str: NSAttributedString, before pos: Int){
		CNExecuteInMainThread(doSync: false, execute: {
			[weak self] () -> Void in
			if let myself = self {
				myself.syncInsert(destinationStorage: myself.textStorage, string: str, before: pos)
				myself.scrollToBottom()
			}
		})
	}

	private func syncInsert(destinationStorage storage: NSTextStorage, string str: NSAttributedString, before pos: Int) {
		/* Get position to insert */
		let mpos: Int
		if pos == KCTextViewCore.INSERTION_POINT, let inpos = syncInsertionPoint() {
			mpos = inpos
		} else {
			mpos = pos
		}
		/* Update current index */
		if let dlg = textViewDelegate as? KCTerminalViewDelegates {
			if mpos <= dlg.lineStartIndex {
				dlg.lineStartIndex += str.string.count
			}
		}
		storage.beginEditing()
		storage.insert(str, at: mpos)
		storage.endEditing()
	}

	public func setNormalAttributes(in range: NSRange) {
		setAttributes(attributes: mNormalAttributes, in: range)
	}

	public func setErrorAttributes(in range: NSRange){
		setAttributes(attributes: mErrorAttributes, in: range)
	}

	private func setAttributes(attributes attrs: [NSAttributedString.Key: Any], in range: NSRange) {
		CNExecuteInMainThread(doSync: false, execute: {
			[weak self] () -> Void in
			if let myself = self {
				#if os(OSX)
					if let storage = myself.mTextView.textStorage {
						storage.setAttributes(attrs, range: range)
					}
				#else
					let storage = myself.mTextView.textStorage
					storage.setAttributes(attrs, range: range)
				#endif
			}
		})
	}

	public func clear(){
		CNExecuteInMainThread(doSync: false, execute: {
			[weak self] () -> Void in
			if let myself = self {
				#if os(OSX)
					if let storage = myself.mTextView.textStorage {
						myself.clear(storage: storage)
					}
				#else
					myself.clear(storage: myself.mTextView.textStorage)
				#endif

			}
		})
	}

	private func clear(storage strg: NSTextStorage){
		/* clear context */
		strg.beginEditing()
		strg.setAttributedString(NSAttributedString(string: ""))
		strg.endEditing()
	}

	#if os(OSX)
	public override func becomeFirstResponder(for window: NSWindow) -> Bool {
		window.makeFirstResponder(mTextView)
		return true
	}
	#endif

	public var color: KCTextColor {
		get	 { return mColor }
		set(col) {
			mColor = col
			mTextView.backgroundColor = col.backgroundColor
		}
	}
}

*/

