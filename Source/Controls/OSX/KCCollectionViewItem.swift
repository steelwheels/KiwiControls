/**
 * @file	KCCollectionViewItem.swift
 * @brief	Define KCCollectionViewItem class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import Cocoa

public class KCCollectionViewItem: NSCollectionViewItem
{
	private var mImageData:   CNImage? = nil

	public var image: CNImage? {
		get         { return mImageData }
		set(newimg) {
			mImageData = newimg
			if let img = newimg, let view = self.imageView {
				view.image = img
			}
		}
	}

	public override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
	}
}
