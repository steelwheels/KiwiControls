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
			ctxt.setStrokeColor(KGColorTable.white.cgColor)
			ctxt.draw(eclipse: mEclipse, withGradient: mGradient)
		}
	}
}

#if true
public func UTVertexLayer(bounds b: CGRect) -> KCRepetitiveDrawer
{
	let glyph = KGGlyph(bounds: b)

	let elmradius = glyph.elementRadius
	let elmbounds = CGRect(origin: CGPoint.zero, size: CGSize(width: elmradius, height: elmradius))

	let drawer = UTVertexDrawer(bounds: elmbounds, color: KGColorTable.gold.cgColor)
	let layer  = KCRepetitiveDrawer(bounds: b, elementDrawer: drawer)

	let halfradius = elmradius / 2.0
	for vertex in glyph.vertices {
		let pt = CGPoint(x: vertex.x - halfradius, y: vertex.y - halfradius)
		layer.add(location: pt)
	}

	return layer
}
#else
public func UTVertexLayer(bounds b: CGRect) -> KCGraphicsLayer
{
	return UTVertexDrawer(bounds: b, color: KGColorTable.gold.cgColor)
}
#endif


