/**
 * @file	KCGraphicsLayer.swift
 * @brief	Define KCGraphicsLayer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import CoreGraphics
import KiwiGraphics
#if os(iOS)
  import UIKit
#else
  import Cocoa
#endif

open class KCGraphicsLayer: KCLayer
{
	private var mLayerDrawer	: KGImageDrawer?

	public init(frame frm: CGRect, drawer drw: @escaping KGImageDrawer){
		mLayerDrawer = drw
		super.init(frame: frm)
		self.image = KGImage.generate(size: frame.size, drawFunc: drw)
	}

	public override init(frame frm: CGRect){
		mLayerDrawer = nil
		super.init(frame: frm)
	}

	public required init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public var layerDrawer: KGImageDrawer? {
		get {
			return mLayerDrawer
		}
		set(drawer){
			mLayerDrawer = drawer
			if let drawer = mLayerDrawer {
				self.image = KGImage.generate(size: frame.size, drawFunc: drawer)
			}
		}
	}
}
