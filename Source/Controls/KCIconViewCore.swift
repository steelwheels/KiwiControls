/**
 * @file	KCIconViewCore.swift
 * @brief	Define KCIconViewCore class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

#if os(OSX)
import Cocoa
#else
import UIKit
#endif
import CoconutData

#if os(OSX)
public class KCIconButtonCell: NSButtonCell {
	public override func highlight(_ flag: Bool, withFrame cellFrame: NSRect, in controlView: NSView) {
		self.isHighlighted = flag
	}
}
#endif

open class KCIconViewCore : KCCoreView
{
	public var buttonPressedCallback: (() -> Void)? = nil

	#if os(OSX)
	@IBOutlet weak var mImageButton: NSButton!
	@IBOutlet weak var mLabelView: NSTextField!
	#else
	@IBOutlet weak var mImageButton: UIButton!
	@IBOutlet weak var mLabelView: UILabel!
	#endif

	private var mSymbol:	CNSymbol	= .character
	private var mSize:	CNSymbolSize	= .regular

	public func setup(frame frm: CGRect){
		super.setup(isSingleView: false, coreView: mImageButton)
		KCView.setAutolayoutMode(views: [self, mImageButton])

		self.title  = "Untitled"
		self.symbol = .character

		#if os(OSX)
		mImageButton.imageScaling	= .scaleProportionallyUpOrDown
		mImageButton.imagePosition	= .imageOnly
		mImageButton.isTransparent	= false	// Required to display icon
		mLabelView.isEditable		= false
		mLabelView.isSelectable		= false
		#else
		mImageButton.contentMode	= .scaleAspectFit
		mImageButton.contentHorizontalAlignment = .fill
		mImageButton.contentVerticalAlignment = .fill
		#endif
	}

	#if os(OSX)
	@IBAction func buttonPressed(_ sender: Any) {
		if let callback = buttonPressedCallback {
			callback()
		}
	}
	#else
	@IBAction func buttonPressed(_ sender: Any) {
		if let callback = buttonPressedCallback {
			callback()
		}
	}
	#endif

	public var symbol: CNSymbol {
		get	     { return mSymbol				 }
		set(newsym)  { setSymbol(symbol: newsym, size: mSize)	 }
	}

	public var size: CNSymbolSize {
		get	     { return mSize    				 }
		set(newsize) { setSymbol(symbol: mSymbol, size: newsize) }
	}

	private func setSymbol(symbol sym: CNSymbol, size sz: CNSymbolSize) {
		let img = sym.load(size: sz)
		#if os(OSX)
			mImageButton.image = img
			mImageButton.needsDisplay = true
			mImageButton.invalidateIntrinsicContentSize()
		#else
			mImageButton.setImage(img, for: .normal)
			mImageButton.setNeedsDisplay()
			mImageButton.invalidateIntrinsicContentSize()
		#endif
		mSymbol = sym
		mSize   = sz
	}

	public var title: String {
		get {
			#if os(OSX)
				return mLabelView.stringValue
			#else
				if let str = mLabelView.text {
					return str
				} else {
					return ""
				}
			#endif
		}
		set(newstr){
			#if os(OSX)
				mLabelView.stringValue = newstr
			#else
				mLabelView.text = newstr
			#endif
			mLabelView.invalidateIntrinsicContentSize()
		}
	}

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		// The size of image is NOT invalidated
	}

	#if os(OSX)
	open override var fittingSize: CGSize {
		get { return contentsSize() }
	}
	#else
	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		return adjustContentsSize(size: size)
	}
	#endif

	open override var intrinsicContentSize: CGSize {
		get { return contentsSize() }
	}

	open override func setFrameSize(_ newsize: CGSize) {
		let _ = adjustContentsSize(size: newsize)
		super.setFrameSize(newsize)
	}

	open override func adjustContentsSize(size tsize: CGSize) -> CGSize {
		var targsize = tsize
		let space    = CNPreference.shared.windowPreference.spacing
		if targsize.height > space {
			targsize.height -= space
		}

		/* Adjust label size */
		let orglabsize = mLabelView.frame.size
		let newlabsize: CGSize
		if orglabsize.height <= targsize.height {
			newlabsize = CGSize(width: targsize.width, height: orglabsize.height)
			targsize.height -= orglabsize.height
		} else {
			newlabsize = CGSize(width: targsize.width, height: targsize.height)
			targsize.height = 0
		}
		mLabelView.setFrame(size: newlabsize)

		/* Adjust button size */
		if targsize.height > space {
			mImageButton.setFrame(size: targsize)
		}
		return tsize
	}

	public override func contentsSize() -> CGSize {
		let imgsize = mSize.toSize()
		let labsize = mLabelView.intrinsicContentSize
		let space   = CNPreference.shared.windowPreference.spacing
		let usize   = CNUnionSize(imgsize, labsize, doVertical: true, spacing: space)
		return CNMinSize(usize, self.limitSize)
	}
}

