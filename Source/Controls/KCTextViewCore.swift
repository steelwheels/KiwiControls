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

open class KCTextViewCore : KCView
{
	#if os(OSX)
		@IBOutlet var mTextView: NSTextView!
	#else
		@IBOutlet weak var mTextView: UITextView!
	#endif

	private var mMinimumColumnNumbers:	Int = 10
	private var mMinimumLineNumbers:	Int = 1

	private var mColor: 	KCTextColor = KCTextColor(
					normal:     KCColorTable.green,
					error:      KCColorTable.red,
					background: KCColorTable.black)

	private var mNormalAttributes: [NSAttributedString.Key: Any] = [:]
	private var mErrorAttributes: [NSAttributedString.Key: Any] = [:]

	public func setup(frame frm: CGRect) {
		updateAttributes()
		if let font = defaultFont {
			mTextView.font = font
		}
		mTextView.backgroundColor = KCColor.black
		self.rebounds(origin: KCPoint.zero, size: frm.size)
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
				#if os(OSX)
				  if let storage = myself.mTextView.textStorage {
					myself.syncAppend(destinationStorage: storage, string: str)
				  }
				#else
				  let storage = myself.mTextView.textStorage
				  myself.syncAppend(destinationStorage: storage, string: str)
				#endif
				myself.scrollToBottom()
			}
		})
	}

	private func syncAppend(destinationStorage storage: NSTextStorage, string str: NSAttributedString){
		storage.beginEditing()
		storage.append(str)
		storage.endEditing()
	}

	private func insert(destinationStorage storage: NSTextStorage, string str: NSAttributedString, at pos: Int) {
		CNExecuteInMainThread(doSync: false, execute: {
			() -> Void in
			storage.beginEditing()
			storage.insert(str, at: pos)
			storage.endEditing()
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
			mTextView.isScrollEnabled = true

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

