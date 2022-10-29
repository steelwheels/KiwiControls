/**
 * @file KCCollectionViewCell.swift
 * @brief	Define KCCollectionViewCell class
 * @par Copyright
 *   Copyright (C) 2023 Steel Wheels Project
 */

import CoconutData
import UIKit

public class KCCollectionViewCell: UICollectionViewCell
{
	public typealias Item = CNCollection.Item

	@IBOutlet weak var mImageView: UIImageView!

	private var mImageURL:	URL? = nil
	private var mImage:	CNImage? = nil

	public override func awakeFromNib() {
		super.awakeFromNib()

		let nrmview = UIView(frame: bounds)
		nrmview.backgroundColor = CNColor.clear
		self.backgroundView = nrmview

		let selview = UIView(frame: bounds)
		selview.backgroundColor = CNColor.cyan
		self.selectedBackgroundView = selview
	}

	public var image: CNImage? { get {
		return mImage
	}}

	public func set(item itm: Item, in width: CGFloat) -> CNImage? {
		var result: CNImage? = nil
		switch itm {
		case .image(let url):
			if let img = CNImage(contentsOf: url) {
				let newsize: CGSize
				if img.size.width > width {
					newsize = img.size.resizeWithKeepingAscpect(inWidth: width)
				} else {
					newsize = img.size
				}
				let newimg  = img.resized(to: newsize)
				mImage		 = newimg
				mImageURL	 = url
				mImageView.image = newimg
				result           = newimg
			} else {
				CNLog(logLevel: .error, message: "Failed to load image from URL(\(url.path))")
			}
		@unknown default:
			CNLog(logLevel: .error, message: "Unknown item type", atFunction: #function, inFile: #file)
		}
		return result
	}

	private func hasSameURL(URL u: URL) -> Bool {
		if let cururl = mImageURL {
			return cururl.path == u.path
		} else {
			return false
		}
	}

	public override func prepareForReuse() {
		mImageURL	 = nil
		mImage	  	 = nil
		mImageView.image = nil
	}
}
