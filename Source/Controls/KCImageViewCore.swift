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

	private var mOriginalImage:	CNImage? = nil
	private var mScale:		CGFloat  = 1.0
	private let mMinimumSize:	CGSize   = CGSize(width: 10.0, height: 10.0)

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
		get { return mOriginalImage }
		set(val){
			mOriginalImage = val
			setupImage()
		}
	}

	public var scale: CGFloat {
		get { return mScale }
		set(val){
			mScale = val
			setupImage()
		}
	}

	private func setupImage(){
		let newsize: CGSize
		if let orgimg = mOriginalImage {
			newsize = CGSize(width: orgimg.size.width * mScale, height: orgimg.size.height * mScale)
			mImageView.image = orgimg
		} else {
			newsize = mMinimumSize
			mImageView.image = nil
		}
		setFrameSize(newsize)
		self.invalidateIntrinsicContentSize()
	}

	public var imageSize: CGSize { get {
		if let img = mImageView.image {
			return img.size
		} else {
			return mMinimumSize
		}
	}}

	#if os(OSX)
	open override var fittingSize: CGSize {
		get { return adjustSize(currentSize: self.imageSize, targetSize: self.frame.size) }
	}
	#else
	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		let result = adjustSize(currentSize: self.imageSize, targetSize: size)
		return result
	}
	#endif

	open override var intrinsicContentSize: CGSize {
		get { return self.imageSize }
	}

	public func adjustContentSize() {
		if let img = mOriginalImage {
			let newsize = adjustSize(currentSize: img.size, targetSize: self.frame.size)
			mImageView.image = img.resize(newsize)
		}
	}

	private func adjustSize(currentSize cursize: CGSize, targetSize targsize: CGSize) -> CGSize {
		guard cursize.width > 0.0 && cursize.height > 0.0 else {
			return mMinimumSize
		}
		guard targsize.width > 0.0 && targsize.height > 0.0 else {
			return mMinimumSize
		}
		guard !(cursize == targsize) else {
			return cursize // needless to resize
		}
		let newsize: CGSize
		let ratio = cursize.width / cursize.height
		if ratio >= 1.0 {
			/* cursize.width >= cursize.height */
			newsize = CGSize(width: targsize.width, height: targsize.width / ratio)
		} else {
			/* cursize.width <  cursize.height */
			newsize = CGSize(width: targsize.height * ratio, height: targsize.height)
		}
		return newsize
	}
}

