/**
 * @file	KCRepetitiveLayer.swift
 * @brief	Define KCRepetitiveLayer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import KiwiGraphics

open class KCRepetitiveLayer: KCLayer, KCDrawerLayerProtocol
{
	private var mElementSize	: CGSize
	private var mElementOrigins	: Array<CGPoint>

	public init(frame f: CGRect,
	            elementSize es: CGSize,
	            elementOrigins eo: Array<CGPoint>,
	            elementDrawer ed: @escaping KGImageDrawer)
	{
		mElementSize	= es
		mElementOrigins	= eo
		super.init(frame: f)
		for origin in eo {
			//Swift.print("repetitive: allocate layers")
			let suborigin = KGOrigin(origin: origin, size: es, frame: f)
			let subrect   = CGRect(origin: suborigin, size: es)
			let sublayer  = KCImageDrawerLayer(frame: f, contentRect: subrect, drawer: ed)
			self.addSublayer(sublayer)
		}
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public var contentRect: CGRect {
		get { return frame }
	}

	public func move(dx xval: CGFloat, dy yval: CGFloat) {
		if let subs = self.sublayers {
			for layer in subs {
				if let drawer = layer as? KCDrawerLayerProtocol {
					drawer.move(dx: xval, dy: yval)
				}
			}
		}
	}

	public func moveTo(x xval: CGFloat, y yval: CGFloat) {
		if let subs = self.sublayers {
			for layer in subs {
				if let drawer = layer as? KCDrawerLayerProtocol {
					drawer.moveTo(x: xval, y: yval)
				}
			}
		}
	}
}


