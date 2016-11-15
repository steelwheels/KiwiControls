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
	var mousePoint: CGPoint

	public override init(bounds b: CGRect){
		mousePoint = CGPoint(x: 0.0, y: 0.0)
		super.init(bounds: b)
	}

	public override func drawContent(context ctxt:CGContext, bounds bnd:CGRect, dirtyRect drect:CGRect){
		let rect = point2rect(point: mousePoint)
		ctxt.addRect(rect)
		ctxt.fillPath()
	}

	public override func mouseEvent(event evt: KCMouseEvent, at point: CGPoint) -> CGRect {
		print("mouseEvent: \(point.description)")
		switch evt {
		case .down:
			print(" down")
		case .drag:
			print(" drag")
		case .up:
			print(" up")
		}
		mousePoint = point
		let update = point2rect(point: point)
		return update
	}

	private func point2rect(point pt:CGPoint) -> CGRect {
		return CGRect(origin: pt, size: CGSize(width: 10, height: 10))
	}
}

