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
		get { return requiredSize() }
	}
	#else
	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		return adjustSize(for: size)
	}
	#endif

	open override var intrinsicContentSize: CGSize {
		get { return requiredSize() }
	}

	open override func setFrameSize(_ newsize: CGSize) {
		let _ = adjustSize(for: newsize)
		super.setFrameSize(newsize)
	}

	private func adjustSize(for tsize: CGSize) -> CGSize {
		let space    = CNPreference.shared.windowPreference.spacing
		let targsize = CNShrinkSize(size: tsize, delta: space)

		/* Adjust label size */
		let orglabsize = mLabelView.frame.size
		let newlabsize: CGSize
		if orglabsize.height <= targsize.height {
			newlabsize = CGSize(width: targsize.width, height: orglabsize.height)
		} else {
			newlabsize = CGSize(width: targsize.width, height: targsize.height)
		}
		mLabelView.setFrame(size: newlabsize)

		/* Adjust button size */
		let btnheight  = targsize.height - (newlabsize.height + space)
		let newbtnsize = CGSize(width: targsize.width, height: btnheight)
		mImageButton.setFrame(size: newbtnsize)

		return CNUnionSize(sizeA: newbtnsize, sizeB: newlabsize, doVertical: true, spacing: CNPreference.shared.windowPreference.spacing)
	}

	private func requiredSize() -> CGSize {
		let btnsize = mSize.toSize() // mImageButton.intrinsicContentSize
		let labsize = mLabelView.intrinsicContentSize
		return CNUnionSize(sizeA: btnsize, sizeB: labsize, doVertical: true, spacing: CNPreference.shared.windowPreference.spacing)
	}

	public override func setExpandabilities(priorities prival: KCViewBase.ExpansionPriorities) {
		super.setExpandabilities(priorities: prival)
		mImageButton.setExpansionPriorities(priorities: prival)
		let labpri = KCViewBase.ExpansionPriorities(holizontalHugging: prival.holizontalHugging,
							    holizontalCompression: prival.holizontalCompression,
							    verticalHugging: .low,
							    verticalCompression: .low)
		mLabelView.setExpansionPriorities(priorities: labpri)
	}
}

