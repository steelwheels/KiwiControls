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
		// Initialization code

		/* Set unhilited background color */
		let whiteView = UIView(frame: bounds)
		whiteView.backgroundColor = .white
		self.backgroundView = whiteView

		/* Set hilited background color */
		let blueView = UIView(frame: bounds)
		blueView.backgroundColor = .cyan
		self.selectedBackgroundView = blueView
	}

	public func set(item itm: Item) {
		switch itm {
		case .image(let url):
			if !hasSameURL(URL: url) {
				if let img = CNImage(contentsOf: url) {
					mImage		 = img
					mImageURL	 = url
					mImageView.image = img
				} else {
					CNLog(logLevel: .error, message: "Failed to load image from URL(\(url.path))")
				}
			}
		@unknown default:
			CNLog(logLevel: .error, message: "Unknown item type", atFunction: #function, inFile: #file)
		}
	}

	public var image: CNImage? { get {
		return mImage
	}}

	private func hasSameURL(URL u: URL) -> Bool {
		if let cururl = mImageURL {
			return cururl.path == u.path
		} else {
			return false
		}
	}

	private var mIsHilighted: Bool		= false
	private var mBackgroundColor: UIColor? 	= nil

	public override func prepareForReuse() {
		mImageURL	 = nil
		mImage	  	 = nil
		mImageView.image = nil
	}
}
