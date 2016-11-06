/**
* @file		KCRepetitiveDrawer.swift
* @brief	Define KCRepetitiveDrawer class
* @par Copyright
*   Copyright (C) 2016 Steel Wheels Project
*/

import Foundation
import KiwiGraphics


open class KCRepetitiveDrawer: KCGraphicsLayer
{
	private var mElementDrawer: KCGraphicsLayer
	private var mLocations	  : Array<CGPoint> = []

	public init(bounds b: CGRect, elementDrawer drawer: KCGraphicsLayer){
		mElementDrawer = drawer
		super.init(bounds: b)
	}

	public func add(location p: CGPoint){
		mLocations.append(p)
	}

	public func add(locations a: Array<CGPoint>){
		mLocations.append(contentsOf: a)
	}

	open override func drawContent(context ctxt:CGContext, bounds bnd:CGRect, dirtyRect drect:CGRect)
	{
		let elmsize = mElementDrawer.bounds.size
		var layer: CGLayer? = nil
		for point in mLocations {
			let elmbounds = CGRect(origin: point, size: elmsize)
			if elmbounds.intersects(drect){
				let elmframe  = CGRect(origin: CGPoint.zero, size: elmsize)
				if layer == nil {
					layer = CGLayer(ctxt, size: elmsize, auxiliaryInfo: nil)
					if let ectxt = layer?.context {
						mElementDrawer.drawContent(context: ectxt, bounds: elmframe, dirtyRect: drect)
					} else {
						NSLog("Could not allocate layer")
					}
				}
				ctxt.draw(layer!, at: point)
			}
		}
	}
}


