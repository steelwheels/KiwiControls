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

open class KCImageViewCore : KCCoreView
{
	#if os(OSX)
	@IBOutlet weak var mImageView: NSImageView!
	#else
	@IBOutlet weak var mImageView: UIImageView!
	#endif

	private var mOriginalImage:	CNImage? = nil
	private var mScale: 		CGFloat  = 1.0

	public func setup(frame frm: CGRect){
		super.setup(isSingleView: true, coreView: mImageView)
		KCView.setAutolayoutMode(views: [self, mImageView])
		#if os(OSX)
			mImageView.imageScaling = .scaleProportionallyUpOrDown
		#else
			mImageView.contentMode = .scaleAspectFit
		#endif
	}

	public var image: CNImage? {
		get {
			return mOriginalImage
		}
		set(imgp){
			if let img = imgp {
				mOriginalImage = img
				updateImage()
			}
		}
	}

	public var scale: CGFloat {
		get {
			return mScale
		}
		set(newval) {
			mScale = newval
			updateImage()
		}
	}

	private func updateImage() {
		if let orgimg = mOriginalImage {
			let orgsize = orgimg.size
			let imgsize = KCSize(width:  orgsize.width *  mScale,
					     height: orgsize.height * mScale)
			mImageView.image = orgimg.resize(imgsize)
		}
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

	#if os(OSX)
	open override var fittingSize: KCSize {
		get { return imageSize }
	}
	#else
	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		return imageSize
	}
	#endif

	open override var intrinsicContentSize: KCSize {
		get { return imageSize }
	}
}

