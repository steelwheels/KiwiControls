/**
 * @file	KCGraphicsDrawer.swift
 * @brief	Define KCGraphicsDrawer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public class KCGraphicsDrawer
{
	private var mGraphicsLayers: Array<KCGraphicsLayer> = []

	public init(){

	}

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

	public func mouseEvent(event evt: KCMouseEvent, at point: CGPoint) -> CGRect {
		var result = CGRect.zero
		let cnt    = mGraphicsLayers.count
		for i in (0..<cnt).reversed() {
			let layer = mGraphicsLayers[i]
			let updaterect = layer.mouseEvent(event: evt, at: point)
			if !updaterect.isEmpty {
				if !result.isEmpty {
					result = result.union(updaterect)
				} else {
					result = updaterect
				}
			}
		}
		return result
	}
}
