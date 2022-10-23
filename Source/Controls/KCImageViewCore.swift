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

	private var mImage:		CNImage? = nil
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
		get { return mImage }
		set(img){
			mImage           = img
			mImageView.image = img
			setupFrameSize()
		}
	}

	public var scale: CGFloat {
		get { return mScale }
		set(newval) {
			mScale = newval
			setupFrameSize()
		}
	}

	private func setupFrameSize() {
		let newsize: CGSize
		if let img = mImage {
			let imgsize = img.size
			newsize = CGSize(width: imgsize.width * mScale, height: imgsize.height * mScale)
		} else {
			newsize = mMinimumSize
		}
		setFrameSize(newsize)
	}

	public var imageSize: CGSize { get {
		if let img = mImage {
			return img.size
		} else {
			return mMinimumSize
		}
	}}

	#if os(OSX)
	open override var fittingSize: CGSize {
		get { return self.imageSize }
	}
	#else
	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		let result: CGSize
		if mImage != nil {
			result = adjustSize(currentSize: self.imageSize, targetSize: size)
		} else {
			result = mMinimumSize
		}
		return result
	}
	#endif

	open override var intrinsicContentSize: CGSize {
		get {
			return adjustSize(currentSize: self.imageSize, targetSize: self.frame.size)
		}
	}

	public func adjustContentSize() {
		if let img = mImage {
			mImageView.image = img.resize(self.frame.size)
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

