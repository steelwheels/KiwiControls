/**
 * @file	KCImageViewCore.swift
 * @brief	Define KCImageViewCore class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

#if os(OSX)
import Cocoa
#else
import UIKit
#endif
import CoconutData

open class KCImageViewCore : KCView
{
	#if os(OSX)
	@IBOutlet weak var mImageView: NSImageView!
	#else
	@IBOutlet weak var mImageView: UIImageView!
	#endif

	private var mScale: CGFloat = 1.0

	public func setup(frame frm: CGRect){
		KCView.setAutolayoutMode(views: [self, mImageView])
		#if os(OSX)
			mImageView.imageScaling = .scaleProportionallyUpOrDown
		#else
			mImageView.contentMode = .scaleAspectFit
		#endif
	}

	public func set(image img: CNImage) {
		mImageView.image = img
	}

	public var scale: CGFloat {
		get		{ return mScale }
		set(newval)	{ mScale = newval}
	}

	open override func setFrameSize(_ newsize: KCSize) {
		super.setFrameSize(newsize)
		//let modsize = fitInAspect(in: newsize)
		#if os(OSX)
		mImageView.setFrameSize(newsize)
		#else
		mImageView.setFrameSize(size: newsize)
		#endif
	}

	/*
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
	}*/

	open override var intrinsicContentSize: KCSize {
		get {
			let imgsize = imageSize
			return KCSize(width: imgsize.width * mScale, height: imgsize.height * mScale)
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

	private var imageSize: CGSize {
		get {
			let imgsize: CGSize
			if let image = mImageView.image {
				imgsize = image.size
			} else {
				imgsize = CGSize.zero
			}
			return imgsize
		}
	}
}

