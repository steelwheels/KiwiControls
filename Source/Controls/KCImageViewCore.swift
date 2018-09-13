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
		let bounds  = CGRect(origin: CGPoint.zero, size: frm.size)
		self.frame  = bounds
		self.bounds = bounds

		#if os(OSX)
			mImageView.imageScaling = .scaleProportionallyUpOrDown
		#else
			mImageView.contentMode = .scaleAspectFit
		#endif
	}

	open override func sizeToFit() {
		mImageView.sizeToFit()
		resize(newSize: mImageView.frame.size)
	}

	public func load(URL file: URL) -> NSError? {
		#if os(OSX)
			if let image = NSImage(contentsOf: file) {
				mImageView.image = image
				return nil
			}
		#else
			do {
				let data = try Data(contentsOf: file)
				if let image = UIImage(data: data) {
					mImageView.image = image
				}
				return nil
			} catch _ {
				/* Do next */
			}
		#endif
		/* Can not load image */
		let fname = file.absoluteString
		return NSError.fileError(message: "Image file \"\(fname)\" is NOT found")
	}

	open override var intrinsicContentSize: KCSize {
		get {
			return mImageView.intrinsicContentSize
		}
	}
}

