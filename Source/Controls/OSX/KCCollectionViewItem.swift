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

	public override func loadView() {
		super.loadView()
		self.view.wantsLayer = true
	}

	public override func viewDidLoad() {
		super.viewDidLoad()
	}

	public override var isSelected: Bool {
		didSet {
			if let layer = self.view.layer {
				if self.isSelected {
					let bgcol  = CNColor.selectedContentBackgroundColor
					let newcol = bgcol.withAlphaComponent(bgcol.alphaComponent * 0.5)
					layer.backgroundColor = newcol.cgColor
				} else {
					layer.backgroundColor = CNColor.clear.cgColor
				}
			}
		}
	}
}
