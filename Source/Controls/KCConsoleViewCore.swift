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

	private var mColor: KCTextColor = KCTextColor(normal:     KCColorTable.black,
						      error:      KCColorTable.red,
						      background: KCColorTable.white)

	public func setup(frame frm: CGRect) {
		self.rebounds(origin: KCPoint.zero, size: frm.size)
	}

	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		let size: KCSize
		if let font = mTextView.font {
			#if os(OSX)
				size = font.boundingRectForFont.size
			#else
				size = KCSize(width: font.lineHeight, height: font.pointSize)
			#endif
			NSLog("Use system font: \(size.description)")
		} else {
			NSLog("Unknown font")
			size = KCSize(width: 20.0, height: 20.0)
		}
		let conssize = KCSize(width:  min(size.width,  size.width  * 40),
				      height: min(size.height, size.height *  4))
		return conssize
	}

	open override func sizeToFit() {
		mTextView.sizeToFit()
		super.resize(mTextView.frame.size)
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

	open override var intrinsicContentSize: KCSize
	{
		return mTextView.intrinsicContentSize
	}
}

