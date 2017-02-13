//
//  UTSymbol.swift
//  KiwiControls
//
//  Created by Tomoo Hamada on 2017/02/07.
//  Copyright © 2017年 Steel Wheels Project. All rights reserved.
//

import Foundation
import KiwiControls
import KiwiGraphics

public func UTAllocateSymbol(symbolId sid: Int, frame frm: CGRect, drawRect drect: CGRect) -> KCImageDrawerLayer
{
	let gtable	= KGGradientTable.sharedGradientTable

	var symbolLayer: KCImageDrawerLayer
	switch sid {
	case 0:
		symbolLayer = KCImageDrawerLayer(frame: frm, drawRect: drect, drawer: {
			(context: CGContext, size: CGSize) -> Void in
			let bounds  = CGRect(origin: CGPoint.zero, size: size)
			let hexagon = KGHexagon(bounds: bounds, lineWidth: 4.0)
			context.setStrokeColor(KGColorTable.cyan.cgColor)
			context.draw(hexagon: hexagon, withGradient: nil)
		})
	case 1:
		let cyangrad = gtable.gradient(forColor: KGColorTable.cyan.cgColor)
		symbolLayer = KCImageDrawerLayer(frame: frm, drawRect: drect, drawer: {
			(context: CGContext, size: CGSize) -> Void in
			let bounds  = CGRect(origin: CGPoint.zero, size: size)
			let hexagon = KGHexagon(bounds: bounds, lineWidth: 4.0)
			context.draw(hexagon: hexagon, withGradient: cyangrad)
		})
	case 2:
		symbolLayer = KCImageDrawerLayer(frame: frm, drawRect: drect, drawer: {
			(context: CGContext, size: CGSize) -> Void in
			let bounds  = CGRect(origin: CGPoint.zero, size: size)
			let hexagon = KGHexagon(bounds: bounds, lineWidth: 4.0)
			context.setStrokeColor(KGColorTable.goldenrod.cgColor)
			context.draw(hexagon: hexagon, withGradient: nil)
		})
	default:
		let goldgrad	= gtable.gradient(forColor: KGColorTable.goldenrod.cgColor)
		symbolLayer = KCImageDrawerLayer(frame: frm, drawRect: drect, drawer: {
			(context: CGContext, size: CGSize) -> Void in
			let bounds  = CGRect(origin: CGPoint.zero, size: size)
			let hexagon = KGHexagon(bounds: bounds, lineWidth: 4.0)
			context.draw(hexagon: hexagon, withGradient: goldgrad)
		})
	}
	symbolLayer.setNeedsDisplay()
	return symbolLayer
}
