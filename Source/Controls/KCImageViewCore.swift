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

	public func setup(frame frm: CGRect){
		self.rebounds(origin: KCPoint.zero, size: frm.size)

		#if os(OSX)
			mImageView.imageScaling = .scaleProportionallyUpOrDown
		#else
			mImageView.contentMode = .scaleAspectFit
		#endif
	}

	open override func sizeToFit() {
		mImageView.sizeToFit()
		super.resize(mImageView.frame.size)
	}

	public func set(image img: CNImage) {
		mImageView.image = img
	}

	open override var intrinsicContentSize: KCSize {
		get {
			return mImageView.intrinsicContentSize
		}
	}
}

