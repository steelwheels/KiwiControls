/**
 * @file	UTSymbol.swift
 * @brief	Unit test for KCImagaDrawer class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation
import KiwiControls
import KiwiGraphics

public func UTAllocateSymbol(symbolId sid: Int, frame frm: CGRect, contentRect crect: CGRect) -> KCImageDrawerLayer
{
	let gtable	= KGGradientTable.sharedGradientTable

	var symbolLayer: KCImageDrawerLayer
	switch sid {
	case 0:
		symbolLayer = KCImageDrawerLayer(frame: frm, contentRect: crect)
		symbolLayer.imageDrawer = {
			(context: CGContext, bounds: CGRect) -> Void in
			let hexagon = KGHexagon(bounds: bounds, lineWidth: 4.0)
			context.setStrokeColor(KGColorTable.cyan.cgColor)
			context.draw(hexagon: hexagon, withGradient: nil)
		}
	case 1:
		let cyangrad = gtable.gradient(forColor: KGColorTable.cyan.cgColor)
		symbolLayer = KCImageDrawerLayer(frame: frm, contentRect: crect)
		symbolLayer.imageDrawer = {
			(context: CGContext, bounds: CGRect) -> Void in
			let hexagon = KGHexagon(bounds: bounds, lineWidth: 4.0)
			context.draw(hexagon: hexagon, withGradient: cyangrad)
		}
	case 2:
		symbolLayer = KCImageDrawerLayer(frame: frm, contentRect: crect)
		symbolLayer.imageDrawer = {
			(context: CGContext, bounds: CGRect) -> Void in
			let hexagon = KGHexagon(bounds: bounds, lineWidth: 4.0)
			context.setStrokeColor(KGColorTable.goldenrod.cgColor)
			context.draw(hexagon: hexagon, withGradient: nil)
		}
	default:
		let goldgrad	= gtable.gradient(forColor: KGColorTable.goldenrod.cgColor)
		symbolLayer = KCImageDrawerLayer(frame: frm, contentRect: crect)
		symbolLayer.imageDrawer = {
			(context: CGContext, bounds: CGRect) -> Void in
			let hexagon = KGHexagon(bounds: bounds, lineWidth: 4.0)
			context.draw(hexagon: hexagon, withGradient: goldgrad)
		}
	}
	return symbolLayer
}
