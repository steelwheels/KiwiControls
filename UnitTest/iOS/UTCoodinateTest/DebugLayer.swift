/**
 * @file	DebugLayer.swift
 * @brief	Define DebugLayer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import KiwiControls

class DebugLayer: KCGraphicsLayer
{
	public override init(bounds b: CGRect){
		super.init(bounds: b)
	}

	public override func drawContent(context ctxt:CGContext, bounds bnd:CGRect, dirtyRect drect:CGRect){
	}

	public override func mouseEvent(event evt: KCMouseEvent, at point: CGPoint) -> KCMouseEventResult {
		print("mouseEvent: \(point.description)")
		switch evt {
		case .down:
			print(" down")
		case .drag:
			print(" drag")
		case .up:
			print(" up")
		}
		return KCMouseEventResult()
	}
}

