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
	#if os(OSX)
	@IBOutlet weak var mImageView: NSImageView!
	@IBOutlet weak var mLabelView: NSTextField!
	#else
	@IBOutlet weak var mImageView: UIImageView!
	@IBOutlet weak var mLabelView: UILabel!
	#endif

	private var mScale: CGFloat	= 1.0

	public func setup(frame frm: CGRect){
		KCView.setAutolayoutMode(views: [self, mImageView])
		#if os(OSX)
			mImageView.imageScaling = .scaleProportionallyUpOrDown
		#else
			mImageView.contentMode = .scaleAspectFit
		#endif
	}

	public var image: CNImage? {
		get		{ return mImageView.image }
		set(newimg)	{ mImageView.image = newimg}
	}

	public var label: String {
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
		set(newlab){
			#if os(OSX)
				mLabelView.stringValue = newlab
			#else
				mLabelView.text = newlab
			#endif
		}
	}

	public var scale: CGFloat {
		get		{ return mScale  }
		set(newscale)	{ mScale = newscale }
	}

	private func divideFrame(entireSize size: KCSize) -> (KCSize, KCSize) { // (size-for-image, size-for-label)
		let space = CNPreference.shared.windowPreference.spacing

		if size.height > mLabelView.frame.size.height + space {
			let labheight = mLabelView.frame.size.height
			let imgheight = size.height - labheight - space
			return (KCSize(width: size.width, height: imgheight),
				KCSize(width: size.width, height: labheight))
		} else {
			let half = KCSize(width: size.width, height: size.height/2.0)
			return (half, half)
		}
	}

	private func fitInAspect(in newsize: KCSize) -> KCSize {
		guard let img = self.mImageView.image else {
			return newsize
		}
		let imgwidth  = img.size.width
		let imgheight = img.size.height
		let imgaspect = imgwidth / imgheight

		let newwidth  = newsize.width
		let newheight = newsize.height
		guard newwidth > 0.0 && newheight > 0.0 else {
			return newsize
		}

		let mod0height = newheight
		let mod0width  = mod0height * imgaspect
		if mod0height <= newsize.height && mod0width <= newsize.width {
			return KCSize(width: mod0width, height: mod0height)
		}

		let mod1width  = newwidth
		let mod1height = mod1width / imgaspect
		return KCSize(width: mod1width, height: mod1height)
	}

	open override func setFrameSize(_ newsize: KCSize) {
		super.setFrameSize(newsize)
		let (imgsize, labsize) = divideFrame(entireSize: newsize)
		let iconsize = fitInAspect(in: imgsize)
		#if os(OSX)
			mImageView.setFrameSize(imgsize)
			mLabelView.setFrameSize(labsize)
		#else
			mImageView.setFrameSize(size: imgsize)
			mLabelView.setFrameSize(size: labsize)
		#endif
		if let img = mImageView.image {
			let _ = img.resize(iconsize)
		}
	}

	open override var intrinsicContentSize: KCSize {
		get {
			let space = CNPreference.shared.windowPreference.spacing
			let imgsize: KCSize
			if let img = mImageView.image {
				imgsize = KCSize(width: img.size.width * mScale, height: img.size.height * mScale)
			} else {
				imgsize = KCSize.zero
			}
			let labsize = mLabelView.intrinsicContentSize
			return KCUnionSize(sizeA: imgsize, sizeB: labsize, doVertical: true, spacing: space)
		}
	}

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		mImageView.invalidateIntrinsicContentSize()
	}

	public override func setExpandabilities(priorities prival: KCViewBase.ExpansionPriorities) {
		mImageView.setExpansionPriorities(priorities: prival)
		super.setExpandabilities(priorities: prival)
	}

	public var imageSize: KCSize {
		get {
			let imgsize: KCSize
			if let image = mImageView.image {
				imgsize = image.size
			} else {
				imgsize = KCSize.zero
			}
			return imgsize
		}
	}

	public var labelSize: KCSize {
		get { return mLabelView.frame.size }
	}
}

