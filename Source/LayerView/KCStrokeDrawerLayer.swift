/**
 * @file	KCStrokeDrawerLayer.swift
 * @brief	Define KCStrokeDrawerLayer class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation
import KiwiGraphics
import Canary

open class KCStrokeDrawerLayer: KCLayer, CALayerDelegate
{
	private var mStrokes	: Array<CGPoint>	= []
	private var mDoClear	: Bool			= true
	public var lineWidth	: CGFloat		= 10.0
	public var lineColor	: CGColor		= KGColorTable.black.cgColor

	public override init(frame f: CGRect) {
		super.init(frame: f)
		self.delegate = self
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public var strokes: Array<CGPoint> {
		get { return mStrokes }
		set(points){
			mStrokes = points
			mDoClear = true
			requrestUpdateIn(dirtyRect: frame)
		}
	}

	public func draw(_ layer: CALayer, in context: CGContext) {
		//Swift.print("KCStrokeDrawerLayer.draw")
		if mDoClear || mStrokes.count == 0 {
			context.clear(bounds)
		}
		if mStrokes.count > 0 {
			context.saveGState()
			#if os(iOS)
				context.translateBy(x: 0.0, y: bounds.size.height)
				context.scaleBy(x: 1.0, y: -1.0)
			#endif
			context.setLineWidth(lineWidth)
			context.setStrokeColor(lineColor)
			context.setLineCap(.round)
			context.setLineJoin(.round)

			context.move(to: mStrokes[0])
			for i in 1..<mStrokes.count {
				context.addLine(to: mStrokes[i])
			}

			context.strokePath()

			context.restoreGState()
		}
		mDoClear = false
	}
}
