/**
* @file		KCRepetitiveDrawer.swift
* @brief	Define KCRepetitiveDrawer class
* @par Copyright
*   Copyright (C) 2016 Steel Wheels Project
*/

import Foundation
import KiwiGraphics


public class KCRepetitiveDrawer: KCGraphicsLayer
{
	private var mElementSize	: CGSize
	private var mDrawer		: (_ context: CGContext, _ size: CGSize) -> Void
	private var mLocations		: Array<CGPoint>

	public init(bounds b: CGRect, elementSize elmsize: CGSize, elementDrawer elmdrw: @escaping ((_ context: CGContext, _ size: CGSize) -> Void))
	{
		mElementSize	= elmsize
		mDrawer		= elmdrw
		mLocations	= []
		super.init(bounds: b)
	}

	public func add(location p: CGPoint){
		mLocations.append(p)
	}
	
	public override func drawContent(context ctxt:CGContext, bounds bnd:CGRect, dirtyRect drect:CGRect)
	{
		var layer: CGLayer? = nil
		for point in mLocations {
			let elmbounds = CGRect(origin: point, size: mElementSize)
			if elmbounds.intersects(drect){
				if layer == nil {
					layer = CGLayer(ctxt, size: mElementSize, auxiliaryInfo: nil)
					if let ectxt = layer?.context {
						mDrawer(ectxt, mElementSize)
					} else {
						NSLog("Could not allocate layer")
					}
				}
				ctxt.draw(layer!, at: point)
			}
		}
	}
}


