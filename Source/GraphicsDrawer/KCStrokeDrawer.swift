/**
 * @file	KCStrokeDrawer.swift
 * @brief	Define KCStrokeDrawer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import KiwiGraphics

let DO_DEBUG = false

open class KCStrokeDrawer: KCGraphicsLayer
{
	private var mCurrentStroke: KGStroke?	= nil
	private var mStrokes: Array<KGStroke>	= []

	public override init(bounds b: CGRect){
		super.init(bounds: b)
	}

	public override func drawContent(context ctxt:CGContext, bounds bnd:CGRect, dirtyRect drect:CGRect){
		Swift.print("dirty:\(drect.description)")
		ctxt.setLineWidth(10.0)
		ctxt.setStrokeColor(KGColorTable.red2.cgColor)

		for s in mStrokes {
			drawStroke(context: ctxt, stroke: s, bounds: bnd, dirtyRect: drect)
		}
		if let s = mCurrentStroke {
			drawStroke(context: ctxt, stroke: s, bounds: bnd, dirtyRect: drect)
		}
		ctxt.strokePath()
	}

	private func drawStroke(context ctxt:CGContext, stroke strk: KGStroke, bounds bnd:CGRect, dirtyRect drect:CGRect){
		Swift.print("drawStroke")
		let points = strk.points
		let count  = points.count
		if count >= 2 {
			var prevpoint = points[0]
			for i in 1..<count {
				let nextpoint = points[i]
				drawPoints(context: ctxt, fromPoint: prevpoint, toPoint: nextpoint, bounds: bnd, dirtyRect: drect)
				prevpoint = nextpoint
			}
		}
	}

	private func drawPoints(context ctxt:CGContext, fromPoint fp: CGPoint, toPoint tp: CGPoint, bounds bnd:CGRect, dirtyRect drect:CGRect){
		Swift.print("drawPoints: \(fp.description) -> \(tp.description)")
		ctxt.move(to: fp)
		ctxt.addLine(to: tp)
	}

	open override func mouseEvent(event evt: KCMouseEvent, at point: CGPoint) -> KCMouseEventResult {
		var didadded    = false
		var updatearea  = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
		switch evt {
		case .down:
			mCurrentStroke = KGStroke(firstPoint: point)
		case .drag:
			if let stroke = mCurrentStroke {
				didadded   = stroke.addPoint(point: point)
				updatearea = stroke.lastUpdatedArea()
			} else {
				mCurrentStroke = KGStroke(firstPoint: point)
			}
		case .up:
			if let stroke = mCurrentStroke {
				didadded       = stroke.addPoint(point: point)
				if didadded {

				}
				mStrokes.append(stroke)
				updatearea   = stroke.lastUpdatedArea()
			}
			mCurrentStroke = nil
		}

		if DO_DEBUG {
			var desc: String
			if let stroke = mCurrentStroke {
				desc = stroke.description
			} else {
				desc = "<none>"
			}
			Swift.print("event:\(evt.description), stroke:\(desc)")
		}

		if didadded {
			//Swift.print("update: \(updatearea.description)")
			return KCMouseEventResult(didAccepted: true, updateRequired: didadded, updateArea: updatearea)
		} else {
			return KCMouseEventResult()
		}
	}
}
