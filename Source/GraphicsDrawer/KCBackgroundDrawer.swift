/**
 * @file	KCBackgroundDrawer.swift
 * @brief	Define KCBackgroundDrawer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import KiwiGraphics
import CoreGraphics

public class KCBackgroundDrawer: KCGraphicsLayer
{
	public var color: CGColor = CGColor.white

	public override func drawContent(context ctxt:CGContext, bounds bnd:CGRect, dirtyRect drect:CGRect){
		ctxt.setFillColor(color)
		ctxt.fill(drect)
	}
}

