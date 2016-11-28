/**
 * @file	KCStrokeDrawer.swift
 * @brief	Define KCStrokeDrawer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import KiwiGraphics

let DO_DEBUG = false

open class KCStrokeLayer: KCLayer
{
	private var mCurrentStroke: KGStroke?	= nil
	private var mStrokes: Array<KGStroke>	= []

	public var lineWidth: CGFloat
	public var lineColor: CGColor

	public override init(frame frm: CGRect){
		lineWidth = 10.0
		lineColor = KGColorTable.black.cgColor
		super.init(frame: frm)
	}

	public required init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	open override func drawContent(in context: CGContext){
		context.setLineWidth(lineWidth)
		context.setStrokeColor(lineColor)
		context.setLineCap(.round)
		context.setLineJoin(.round)
		for s in mStrokes {
			drawStroke(in: context, stroke: s)
		}
		if let s = mCurrentStroke {
			drawStroke(in: context, stroke: s)
		}
		context.strokePath()
	}

	private func drawStroke(in context:CGContext, stroke strk: KGStroke){
		//Swift.print("drawStroke")
		let points = strk.points
		let count  = points.count
		if count >= 2 {
			var prevpoint = points[0]
			for i in 1..<count {
				let nextpoint = points[i]
				drawPoints(in: context, fromPoint: prevpoint, toPoint: nextpoint)
				prevpoint = nextpoint
			}
		}
	}

	private func drawPoints(in context:CGContext, fromPoint fp: CGPoint, toPoint tp: CGPoint){
		context.move(to: fp)
		context.addLine(to: tp)
	}

	open override func mouseEvent(event evt: KCMouseEvent, at point: CGPoint) {
		var result	: CGRect = CGRect.zero
		var didadded	: Bool

		switch evt {
		case .down:
			mCurrentStroke = KGStroke(firstPoint: point)
			didadded = false
		case .drag:
			if let stroke = mCurrentStroke {
				didadded = stroke.addPoint(point: point)
				result   = expandByLineWidth(source: stroke.lastUpdatedArea())
			} else {
				mCurrentStroke = KGStroke(firstPoint: point)
				didadded = false
			}
		case .up:
			if let stroke = mCurrentStroke {
				didadded = stroke.addPoint(point: point)
				if stroke.points.count >= 2 {
					mStrokes.append(stroke)
					result = expandByLineWidth(source: stroke.lastUpdatedArea())
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
			//Swift.print("AddedPoint: \(point.description)")
			self.setNeedsDisplayIn(result)
		}

		super.mouseEvent(event: evt, at: point)
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
