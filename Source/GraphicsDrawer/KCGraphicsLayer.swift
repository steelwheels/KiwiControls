/**
 * @file	KCGraphicsLayer.swift
 * @brief	Define KCGraphicsLayer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import CoreGraphics

open class KCGraphicsLayer
{
	public  var	bounds: CGRect

	public init(bounds b: CGRect){
		bounds = b
	}

	open func drawContent(context ctxt:CGContext, bounds bnd:CGRect, dirtyRect drect:CGRect){
	}

	open func mouseEvent(event evt: KCMouseEvent, at point: CGPoint) -> CGRect {
		return CGRect.zero
	}
}
