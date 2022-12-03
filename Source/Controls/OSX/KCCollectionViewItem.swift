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
	private var mTextField:	  NSTextField

	public override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
		mTextField = NSTextField(frame: NSRect.zero)
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.textField = mTextField
	}

	required init?(coder: NSCoder) {
		mTextField = NSTextField(frame: NSRect.zero)
		super.init(coder: coder)
		self.textField = mTextField
	}

	public var image: CNImage? { get {
		return mImageData
	}}

	public func set(symbol sym: CNSymbol, size sz: CNSymbolSize) -> CNImage? {
		let img    = sym.load(size: sz.toSize())
		mImageData = img
		if let view = self.imageView {
			view.image = img
		}
		return img
	}

	public override func loadView() {
		super.loadView()
	}

	public override func viewDidLoad() {
		super.viewDidLoad()
		self.view.layer = self.view.makeBackingLayer()
		self.view.wantsLayer = true
	}

	public override func viewWillAppear() {
		super.viewWillAppear()
	}

	public override var isSelected: Bool {
		didSet {
			if let layer = self.view.layer {
				let newcol = self.isSelected ? CNColor.cyan : CNColor.clear
				layer.backgroundColor = newcol.cgColor
			}
		}
	}

	/*
	private func setBackgroundColor(hasColor hascol: Bool){
		if let layer = self.view.layer {
			let bgcolor: CNColor
			if hascol {
				let col  = CNColor.selectedContentBackgroundColor
				bgcolor = col.withAlphaComponent(col.alphaComponent * 0.5)
			} else {
				bgcolor = CNColor.clear
			}
			layer.backgroundColor = bgcolor.cgColor
		} else {
			CNLog(logLevel: .error, message: "No layer", atFunction: #function, inFile: #file)
		}
	}*/
}
