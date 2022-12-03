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
		mImageButton.isTransparent	= true
		mLabelView.isEditable		= false
		mLabelView.isSelectable		= false
		#else
		mImageButton.contentMode	= .scaleAspectFit
		//mImageButton.imagePosition	= .imageAbove
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
		get {
			#if os(OSX)
				return mSymbol
			#else
				return mSymbol
			#endif
		}
		set(newsym)	{
			let img = newsym.load(size: mSize)
			#if os(OSX)
				mImageButton.image = img
			#else
				mImageButton.setImage(img, for: .normal)
			#endif
			mImageButton.invalidateIntrinsicContentSize()
			mSymbol = newsym
		}
	}

	public var size: CNSymbolSize {
		get	     { return mSize    }
		set(newsize) { mSize = newsize }
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
		return requiredSize()
	}
	#endif

	open override var intrinsicContentSize: CGSize {
		get { return requiredSize() }
	}

	private func requiredSize() -> CGSize {
		let btnsize = mImageButton.intrinsicContentSize
		let labsize = mLabelView.intrinsicContentSize
		return CNUnionSize(sizeA: btnsize, sizeB: labsize, doVertical: true, spacing: CNPreference.shared.windowPreference.spacing)
	}

	private func imageInButton() -> CNImage? {
		#if os(OSX)
			return mImageButton.image
		#else
			return mImageButton.image(for: .normal)
		#endif
	}

	private func setImageToButton(image img: CNImage) {
		#if os(OSX)
			mImageButton.image = img
		#else
		mImageButton.setImage(img, for: .normal)
		#endif
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

