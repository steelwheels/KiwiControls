/**
 * @file	KCGraphicsDrawer.h
 * @brief	Define KCGraphicsDrawer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public class KGGraphicsDrawer
{
	private var mGraphicsLayers: Array<KCGraphicsLayer> = []

	public func addLayer(layer l: KCGraphicsLayer) {
		mGraphicsLayers.append(l)
	}

	public func drawContent(context ctxt:CGContext, bounds bnd:CGRect, dirtyRect drect:CGRect){
		for layer in mGraphicsLayers {
			if layer.bounds.intersects(drect) {
				layer.drawContent(context: ctxt, bounds: bnd, dirtyRect: drect)
			}
		}
	}
}
