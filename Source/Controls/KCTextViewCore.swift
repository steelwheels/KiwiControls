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
import CoconutShell

open class KCTextViewCore : KCView
{
	public static let INSERTION_POINT	= -1

	public enum TextViewType {
		case	console
		case	terminal
	}

	#if os(OSX)
		@IBOutlet var mTextView: NSTextView!
	#else
		@IBOutlet weak var mTextView: UITextView!
	#endif

	private var mViewType:			TextViewType = .console
	private var mTextViewDelegates:		KCTextViewDelegates? = nil
	private var mMinimumColumnNumbers:	Int = 10
	private var mMinimumLineNumbers:	Int = 1

	private var mColor: 	KCTextColor = KCTextColor(
					normal:     KCColorTable.green,
					error:      KCColorTable.red,
					background: KCColorTable.black)

	private var mNormalAttributes: [NSAttributedString.Key: Any] = [:]
	private var mErrorAttributes: [NSAttributedString.Key: Any] = [:]

	public func setup(type typ: TextViewType, frame frm: CGRect, output outhdl: FileHandle?) {
		updateAttributes()
		if let font = defaultFont {
			mTextView.font = font
		}
		self.rebounds(origin: KCPoint.zero, size: frm.size)
		mTextView.translatesAutoresizingMaskIntoConstraints = true // Keep true to scrollable
		mTextView.autoresizesSubviews = true
		mTextView.backgroundColor     = KCColor.black
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
		#if os(OSX)
			mTextView.isVerticallyResizable   = true
			mTextView.isHorizontallyResizable = false
			mTextView.insertionPointColor	  = KCColor.green
		#else
			mTextView.isScrollEnabled = true
		#endif
		mViewType = typ
		switch typ {
		case .console:
			mTextView.isEditable			= false
			mTextView.isSelectable			= false
		case .terminal:
			mTextView.isEditable			= true
			mTextView.isSelectable			= true
		}
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
		if let font = defaultFont {
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

	private var defaultFont: KCFont? {
		get {
			#if os(OSX)
				return KCFont.userFixedPitchFont(ofSize: 12.0)
			#else
				return KCFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .regular)
			#endif
		}
	}

	public var minimumColumnNumbers: Int {
		get { return mMinimumColumnNumbers }
		set(newnum){
			if newnum > 0 {
				mMinimumColumnNumbers = newnum
			} else {
				NSLog("Invalid parameter value: \(newnum)")
			}
		}
	}

	public var minimumLineNumbers: Int {
		get { return mMinimumLineNumbers }
		set(newnum){
			if newnum > 0 {
				mMinimumLineNumbers = newnum
			} else {
				NSLog("Invalid parameter value: \(newnum)")
			}
		}
	}

	public var columnNumbers: Int {
		get { return Int(self.bounds.width / fontSize().width) }
	}

	public var lineNumbers: Int {
		get { return Int(self.bounds.height / fontSize().height) }
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

	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		let fontsize  = fontSize()
		let reqwidth  = KCScreen.shared.pointToPixel(point: fontsize.width  * CGFloat(minimumColumnNumbers))
		let reqheight = KCScreen.shared.pointToPixel(point: fontsize.height * CGFloat(minimumLineNumbers))
		let reqsize   = KCSize(width: reqwidth, height: reqheight)

		let result = KCSize(width: min(size.width,   reqsize.width),
				    height: min(size.height, reqsize.height))
		return result
	}

	open override var intrinsicContentSize: KCSize {
		get {
			if hasFixedSize {
				return super.intrinsicContentSize
			} else {
				return mTextView.intrinsicContentSize
			}
		}
	}

	open override func resize(_ size: KCSize) {
		mTextView.frame.size  = size
		mTextView.bounds.size = size
		super.resize(size)
	}

	private func syncInsertionPoint() -> Int? {
		#if os(OSX)
			let values = mTextView.selectedRanges
			for value in values {
				let range = value.rangeValue
				if range.length == 0 {
					return range.location
				}
			}
			return nil
		#else
			return mTextView.selectedRange.location
		#endif
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

	public var color: KCTextColor {
		get	 { return mColor }
		set(col) {
			mColor = col
			mTextView.backgroundColor = col.backgroundColor
		}
	}
}

