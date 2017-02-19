/**
 * @file	KCStrokeEditorLayer.swift
 * @brief	Define KCStrokeEditorLayer class
 * @par Copyright
 *   Copyright (C) 2016-2017 Steel Wheels Project
 */

import Foundation
import KiwiGraphics

let DO_DEBUG = false

open class KCStrokeEditorLayer: KCLayer, CALayerDelegate
{
	private var mCurrentStroke	: KGStroke?		= nil
	private var mStrokes		: Array<KGStroke>	= []

	public var lineWidth		: CGFloat		= 10.0
	public var lineColor		: CGColor		= KGColorTable.black.cgColor

	public override init(frame f:CGRect) {
		super.init(frame: f)
		self.delegate = self
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
			requrestUpdateIn(dirtyRect: result)
			doUpdate()
		}
	}

	public func draw(_ layer: CALayer, in context: CGContext) {
		context.saveGState()
		#if os(iOS)
			context.translateBy(x: 0.0, y: bounds.size.height)
			context.scaleBy(x: 1.0, y: -1.0)
		#endif
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

		context.restoreGState()
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

	private func expandByLineWidth(source src:CGRect) -> CGRect {
		let lwidth = lineWidth / 2.0
		let x      = src.origin.x - lwidth
		let y      = src.origin.y - lwidth
		let width  = src.size.width  + lineWidth
		let height = src.size.height + lineWidth
		return CGRect(x: x, y: y, width: width, height: height)
	}
}

