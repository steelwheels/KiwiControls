/**
* @file		KCRepetitiveDrawer.swift
* @brief	Define KCRepetitiveDrawer class
* @par Copyright
*   Copyright (C) 2016 Steel Wheels Project
*/

import Foundation
import KiwiGraphics


open class KCRepetitiveLayer: KCLayer
{
	private var mElementSize	: CGSize
	private var mElementDrawer	: KGImageDrawer

	public init(frame frm: CGRect, elementSize es:CGSize, elementDrawer ed: @escaping KGImageDrawer){
		mElementSize   = es
		mElementDrawer = ed
		super.init(frame: frm)
	}
	
	public required init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public func add(location p: CGPoint){
		let eframe = CGRect(origin: p + bounds.origin, size: mElementSize)
		let layer  = KCGraphicsLayer(frame: eframe, drawer: mElementDrawer)
		self.addSublayer(layer)
	}
}


