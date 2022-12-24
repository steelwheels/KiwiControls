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
	@IBOutlet weak var mImageView: UIImageView!

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

	public func set(symbol sym: CNSymbol, size sz: CNSymbolSize) -> CNImage {
		let img = sym.load(size: sz)
		mImage           = img
		mImageView.image = img
		return img
	}

	public override func prepareForReuse() {
		mImage	  	 = nil
		mImageView.image = nil
	}
}
