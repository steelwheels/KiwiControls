//
//  UTVertexLayer.swift
//  KiwiControls
//
//  Created by Tomoo Hamada on 2016/10/09.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Foundation
import KiwiControls
import KiwiGraphics

private class UTVertexDrawer: KCGraphicsLayer
{
	private var mEclipse:	KGEclipse
	private var mGradient:	CGGradient

	public init(bounds b: CGRect, color c: CGColor){
		let center = b.center
		let radius = min(b.size.width, b.size.height)/2.0
		mEclipse  = KGEclipse(center: center, innerRadius: radius*0.4, outerRadius: radius)
		mGradient = KGGradientTable.sharedGradientTable.gradient(forColor: c)
		super.init(bounds: b)
	}

	public override func drawContent(context ctxt:CGContext, bounds bnd:CGRect, dirtyRect drect:CGRect){
		if bnd.intersects(drect) {
			ctxt.setStrokeColor(KGColorTable.gold.cgColor)
			ctxt.draw(eclipse: mEclipse, withGradient: mGradient)
		}
	}
}

#if true
public func UTVertexLayer(bounds b: CGRect) -> KCRepetitiveDrawer
{
	let elmradius = min(b.size.width, b.size.height) * 0.075
	let elmsize   = CGSize(width: elmradius, height: elmradius)
	let elmbounds = CGRect(origin: CGPoint.zero, size: elmsize)

	let drawer = UTVertexDrawer(bounds: elmbounds, color: KGColorTable.gold.cgColor)
	let layer  = KCRepetitiveDrawer(bounds: b, elementDrawer: drawer)

	/* Get center and radius of bounds */
	let center = b.center
	let radius = (min(b.size.width, b.size.height) / 2.0) - elmradius

	/* Point of hexagon */
	var points: Array<CGPoint> = []
	let pi2  = 2.0 * CGFloat.pi
	let diff = pi2 / 6.0
	for i in 0..<6 {
		let angle = CGFloat(i) * diff
		let y = radius * cos(angle)
		let x = radius * sin(angle)
		let pt = CGPoint(x: center.x + x, y: center.y + y)
		points.append(pt)
	}

	let diff5_2 = points[5] - points[2]
	let point6  = points[2] + (diff5_2 * (3.0 / 4.0))
	points.append(point6)
	let point7  = points[2] + (diff5_2 * (2.0 / 4.0))
	points.append(point7)
	let point8  = points[2] + (diff5_2 * (1.0 / 4.0))
	points.append(point8)

	let diff4_1 = points[4] - points[1]
	let point9  = points[1] + (diff4_1 * (3.0 / 4.0))
	points.append(point9)
	let point10 = points[1] + (diff4_1 * (1.0 / 4.0))
	points.append(point10)

	layer.add(locations: points)

	return layer
}
#else
public func UTVertexLayer(bounds b: CGRect) -> KCGraphicsLayer
{
	return UTVertexDrawer(bounds: b, color: KGColorTable.gold.cgColor)
}
#endif


