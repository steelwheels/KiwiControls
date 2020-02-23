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
		KCView.setAutolayoutMode(views: [self, mImageView])
		self.rebounds(origin: KCPoint.zero, size: frm.size)

		#if os(OSX)
			mImageView.imageScaling = .scaleProportionallyUpOrDown
		#else
			mImageView.contentMode = .scaleAspectFit
		#endif
	}

	public func set(image img: CNImage) {
		mImageView.image = img
	}

	open override var fittingSize: KCSize {
		get {
			return imageSize
		}
	}

	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		return fittingSize(source: imageSize, in: size)
	}

	open override var intrinsicContentSize: KCSize {
		get {
			if hasFixedSize {
				return super.intrinsicContentSize
			} else if let image = mImageView.image {
				return image.size
			} else {
				return KCSize.zero
			}
		}
	}

	open override func resize(_ size: KCSize) {
		//NSLog("image: resize = \(size.description)")
		if let image = mImageView.image {
			mImageView.image = image.resize(size)
		}
		super.resize(size)
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
		set(newsize){
			if let image = mImageView.image {
				let newsize = fittingSize(source: image.size, in: newsize)
				let newimg  = image.resize(newsize)
				mImageView.image = newimg
			}
		}
	}

	private func fittingSize(source src: KCSize, in bounds: KCSize) -> KCSize {
		let result: CGSize
		if src.width == 0 || src.height == 0 || bounds.width == 0.0 || bounds.height == 0.0{
			result = CGSize.zero
		} else if src.width <= bounds.width && src.height <= bounds.height {
			result = src
		} else {
			let hratio = src.width  / bounds.width
			let vratio = src.height / bounds.height
			if hratio >= vratio {
				result = CGSize(width: src.width / hratio, height: src.height / hratio)
			} else {
				result = CGSize(width: src.width / vratio, height: src.height / vratio)
			}
		}
		NSLog("Adjusted image size: \(src.description) in \(bounds.description) -> \(result.description)")
		return result
	}
}

