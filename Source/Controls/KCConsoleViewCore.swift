/**
 * @file	KCConsoleViewCore.swift
 * @brief Define KCConsoleViewCore class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCConsoleViewCore : KCView
{
	#if os(OSX)
		@IBOutlet var mTextView: NSTextView!
	#else
		@IBOutlet weak var mTextView: UITextView!
	#endif

	private var mMinimumColumnNumbers:	Int = 10
	private var mMinimumLineNumbers:	Int = 1

	private var mColor: 			KCTextColor = KCTextColor(normal:     KCColorTable.black,
						      error:      KCColorTable.red,
						      background: KCColorTable.white)

	public func setup(frame frm: CGRect) {
		setFont(size: 10.0)
		self.rebounds(origin: KCPoint.zero, size: frm.size)
	}

	private func setFont(size sz: CGFloat){
		let font = KCFont.systemFont(ofSize: sz)
		#if os(OSX)
			let range: NSRange
			if let storage = mTextView.textStorage {
				range = NSRange(location: 0, length: storage.string.lengthOfBytes(using: .utf8))
				storage.append(NSAttributedString(string: "*HELLO*"))
			} else {
				range = NSRange(location: 0, length: 0)
			}
			mTextView.setFont(font, range: range)
		#else
			mTextView.font = font
		#endif
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

	public func fontSize() -> KCSize {
		let size: KCSize
		#if os(OSX)
			if let font = mTextView.font {
				size = font.boundingRectForFont.size
				log(type: .Flow, string: "fontSize: \(size.description)", file: #file, line: #line, function: #function)
			} else {
				log(type: .Error, string: "No Font", file: #file, line: #line, function: #function)
				size = KCSize(width: 10.0, height: 10.0)
			}
		#else
			if let font = mTextView.font {
				size = KCSize(width: font.lineHeight, height: font.pointSize)
				log(type: .Flow, string: "fontSize: \(size.description)", file: #file, line: #line, function: #function)
			} else {
				log(type: .Error, string: "No Font", file: #file, line: #line, function: #function)
				size = KCSize(width: 10.0, height: 10.0)
			}
		#endif




		return size
	}

	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		let fontsize  = fontSize()
		let reqwidth  = fontsize.width  * CGFloat(minimumColumnNumbers)
		let reqheight = fontsize.height * CGFloat(minimumLineNumbers)
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

	public func appendText(string str: NSAttributedString){
		CNExecuteInMainThread(doSync: false, execute: {
			[weak self] () -> Void in
			if let myself = self {
				#if os(OSX)
				  if let storage = myself.mTextView.textStorage {
					myself.appendText(destinationStorage: storage, string: str)
				  }
				#else
				  let storage = myself.mTextView.textStorage
				  myself.appendText(destinationStorage: storage, string: str)
				#endif
				myself.scrollToBottom()
			}
		})
	}

	private func appendText(destinationStorage storage: NSTextStorage, string str: NSAttributedString){
		storage.beginEditing()
		storage.append(str)
		storage.endEditing()
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

