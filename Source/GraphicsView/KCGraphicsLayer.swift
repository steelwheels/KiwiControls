/**
 * @file	KCGraphicsLayer.swift
 * @brief	Define KCGraphicsLayer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import CoreGraphics
import Cocoa
import KiwiGraphics

open class KCGraphicsLayer: KCLayer
{
	private var mLayerDrawer	: KGImageDrawer

	public init(frame frm: CGRect, drawer drw: @escaping KGImageDrawer){
		mLayerDrawer = drw
		super.init(frame: frm)
		super.image = NSImage.generate(size: frm.size, drawFunc: mLayerDrawer)
	}

	public required init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
