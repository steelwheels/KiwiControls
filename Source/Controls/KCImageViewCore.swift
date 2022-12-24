/**
 * @file	KCImageViewCore.swift
 * @brief	Define KCImageViewCore class
 * @par Copyright
 *   Copyright (C) 2018-2022 Steel Wheels Project
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

	private var mScale:		CGFloat  = 1.0
	private let mMinimumSize:	CGSize   = CGSize(width: 10.0, height: 10.0)

	public func setup(frame frm: CGRect){
		super.setup(isSingleView: true, coreView: mImageView)
		KCView.setAutolayoutMode(views: [self, mImageView])
		#if os(OSX)
			mImageView.imageScaling = .scaleProportionallyUpOrDown
		#else
			mImageView.contentMode  = .scaleAspectFit
		#endif
	}


	public var image: CNImage? {
		get {
			return mImageView.image
		}
		set(val){
			if let img = val {
				mImageView.image = img
				setupImage(image: img, scale: mScale)
			} else {
				mImageView.image = nil
			}
		}
	}

	public var scale: CGFloat {
		get {
			return mScale
		}
		set(val){
			mScale = val
			setupImage(image: mImageView.image, scale: mScale)
		}
	}

	private func setupImage(image imgp: CNImage?, scale scl: CGFloat){
		let newsize: CGSize
		if let orgimg = imgp {
			newsize = CGSize(width: orgimg.size.width * scl, height: orgimg.size.height * scl)
			mImageView.image = orgimg
		} else {
			newsize = mMinimumSize
			mImageView.image = nil
		}
		setFrameSize(newsize)
		#if os(iOS)
		mImageView.center = CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0)
		#endif
		self.invalidateIntrinsicContentSize()
	}

	public var imageSize: CGSize { get {
		if let img = mImageView.image {
			return CNMinSize(sizeA: img.size, sizeB: self.limitSize)
		} else {
			return mMinimumSize
		}
	}}

	#if os(OSX)
	open override var fittingSize: CGSize { get {
		if let img = mImageView.image {
			return img.size
		} else {
			return mMinimumSize
		}
	}}
	#else
	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		if let img = mImageView.image {
			return img.size.resizeWithKeepingAscpect(inSize: size)
		} else {
			return mMinimumSize
		}
	}
	#endif

	open override var intrinsicContentSize: CGSize {
		get { return self.imageSize }
	}
}

