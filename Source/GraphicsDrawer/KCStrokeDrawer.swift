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

	public var lineWidth: CGFloat
	public var lineColor: KGColor

	public override init(bounds b: CGRect){
		lineWidth = 10.0
		lineColor = KGColorTable.black
		super.init(bounds: b)
	}

	open override func drawContent(context ctxt:CGContext, bounds bnd:CGRect, dirtyRect drect:CGRect){
		//Swift.print("dirty:\(drect.description)")
		ctxt.setLineWidth(lineWidth)
		ctxt.setStrokeColor(lineColor.cgColor)
		ctxt.setLineCap(.round)

		for s in mStrokes {
			drawStroke(context: ctxt, stroke: s, bounds: bnd, dirtyRect: drect)
		}
		if let s = mCurrentStroke {
			drawStroke(context: ctxt, stroke: s, bounds: bnd, dirtyRect: drect)
		}
		ctxt.strokePath()
	}

	private func drawStroke(context ctxt:CGContext, stroke strk: KGStroke, bounds bnd:CGRect, dirtyRect drect:CGRect){
		//Swift.print("drawStroke")
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
		//Swift.print("drawPoints: \(fp.description) -> \(tp.description) in \(drect.description)")
		let drawrect = CGRect.pointsToRect(fromPoint: fp, toPoint: tp)
		if drawrect.intersects(drect){
			ctxt.move(to: fp)
			ctxt.addLine(to: tp)
		}
	}

	open override func mouseEvent(event evt: KCMouseEvent, at point: CGPoint) -> KCMouseEventResult {
		var updatearea  = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
		var didadded: Bool

		switch evt {
		case .down:
			mCurrentStroke = KGStroke(firstPoint: point)
			didadded = false
		case .drag:
			if let stroke = mCurrentStroke {
				didadded = stroke.addPoint(point: point)
				updatearea = expandByLineWidth(source: stroke.lastUpdatedArea())
			} else {
				mCurrentStroke = KGStroke(firstPoint: point)
				didadded = false
			}
		case .up:
			if let stroke = mCurrentStroke {
				didadded = stroke.addPoint(point: point)
				if stroke.points.count >= 2 {
					mStrokes.append(stroke)
					updatearea   = expandByLineWidth(source: stroke.lastUpdatedArea())
				}
			} else {
				didadded = false
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

	private func expandByLineWidth(source src:CGRect) -> CGRect {
		let lwidth = lineWidth / 2.0
		let x      = src.origin.x - lwidth
		let y      = src.origin.y - lwidth
		let width  = src.size.width  + lineWidth
		let height = src.size.height + lineWidth
		return CGRect(x: x, y: y, width: width, height: height)
	}
}
