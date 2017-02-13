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
			let suborigin = calcOrigin(elementOrigin: origin, elementSize: es, entireFrame: f)
			let subframe  = CGRect(origin: suborigin, size: es)
			let sublayer  = KCImageDrawerLayer(frame: subframe, drawRect: subframe, drawer: ed)
			sublayer.setNeedsDisplay()
			self.addSublayer(sublayer)
		}
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func calcOrigin(elementOrigin elmorg: CGPoint, elementSize elmsz: CGSize, entireFrame frame: CGRect) -> CGPoint {
		let origin: CGPoint
		#if os(iOS)
			origin = CGPoint(x: elmorg.x, y: frame.size.height - elmsz.height - elmorg.y)
		#else
			origin = CGPoint(x: elmorg.x, y: elmorg.y)
		#endif
		return origin
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


