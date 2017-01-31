/**
 * @file	KCStrokeDrawerLayer.swift
 * @brief	Define KCStrokeDrawerLayer class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation
import KiwiGraphics

public class KCStrokeDrawerLayer: KCLayer, CALayerDelegate
{
	private var mStroke	: Array<CGPoint>	= []
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

	public var stroke: Array<CGPoint> {
		get { return mStroke }
		set(points){
			mStroke  = points
			mDoClear = true
			super.setNeedsDisplay()
		}
	}

	public func draw(_ layer: CALayer, in context: CGContext) {
		//Swift.print("KCStrokeDrawerLayer.draw")
		if mDoClear || mStroke.count == 0 {
			context.clear(bounds)
		}
		if mStroke.count > 0 {
			context.saveGState()
			#if os(iOS)
				context.translateBy(x: 0.0, y: bounds.size.height)
				context.scaleBy(x: 1.0, y: -1.0)
			#endif
			context.setLineWidth(lineWidth)
			context.setStrokeColor(lineColor)
			context.setLineCap(.round)
			context.setLineJoin(.round)

			context.move(to: mStroke[0])
			for i in 1..<mStroke.count {
				context.addLine(to: mStroke[i])
			}

			context.strokePath()

			context.restoreGState()
		}
		mDoClear = false
	}
}
