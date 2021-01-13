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

open class KCIconViewCore : KCView
{
	public var buttonPressedCallback: (() -> Void)? = nil

	#if os(OSX)
	@IBOutlet weak var mImageButton: NSButton!
	@IBOutlet weak var mLabelView: NSTextField!
	#else
	@IBOutlet weak var mImageButton: UIButton!
	@IBOutlet weak var mLabelView: UILabel!
	#endif

	private var mScale: CGFloat	= 1.0
	private var mOriginalImageSize	= KCSize.zero

	public func setup(frame frm: CGRect){
		KCView.setAutolayoutMode(views: [self, mImageButton])
		self.title = "Untitled"
		#if os(OSX)
		mImageButton.imageScaling	= .scaleProportionallyUpOrDown
		mImageButton.imagePosition	= .imageOnly
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

	public var image: CNImage? {
		get {
			#if os(OSX)
				return mImageButton.image
			#else
				return mImageButton.image(for: .normal)
			#endif
		}
		set(newimg)	{
			guard let img = newimg else {
				CNLog(logLevel: .error, message: "No image")
				return
			}
			#if os(OSX)
				mImageButton.image = img
			#else
				mImageButton.setImage(img, for: .normal)
			#endif
			mOriginalImageSize = img.size
		}
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
		}
	}

	public var scale: CGFloat {
		get		{ return mScale  }
		set(newscale)	{ mScale = newscale }
	}

	open override func setFrameSize(_ newsize: KCSize) {
		super.setFrameSize(newsize)

		var labheight = mLabelView.frame.size.height
		var imgheight = newsize.height - labheight
		if imgheight < 0.0 {
			labheight = newsize.height / 2.0
			imgheight = labheight
		}
		let labsize = KCSize(width: newsize.width, height: labheight)
		let imgsize = KCSize(width: newsize.width, height: imgheight)
		#if os(OSX)
		mImageButton.setFrameSize(imgsize)
		mLabelView.setFrameSize(labsize)
		#else
		mImageButton.setFrameSize(size: imgsize)
		mLabelView.setFrameSize(size: labsize)
		#endif
	}

	open override var intrinsicContentSize: KCSize {
		get {
			/* Get image size */
			let sclsize = KCSize(width:  mOriginalImageSize.width  * mScale,
					     height: mOriginalImageSize.height * mScale)
			if let img = self.image {
				let _ = img.resize(sclsize)
			}
			let imgsize = mImageButton.intrinsicContentSize
			/* Get label size */
			let labsize = mLabelView.intrinsicContentSize
			return KCUnionSize(sizeA: imgsize, sizeB: labsize, doVertical: true, spacing: 0.0)
		}
	}

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		mImageButton.invalidateIntrinsicContentSize()
	}

	public override func setExpandabilities(priorities prival: KCViewBase.ExpansionPriorities) {
		mImageButton.setExpansionPriorities(priorities: prival)
		super.setExpandabilities(priorities: prival)
	}
}

