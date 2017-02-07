/**
 * @file	KCLayer.swift
 * @brief	Define KCLayer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import KiwiGraphics
import CoreGraphics
#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif

private func convertCoodinate(sourceRect r: CGRect, bounds b: CGRect) -> CGRect
{
	let y = (b.size.height - (r.size.height + r.origin.y))
	return CGRect(x: r.origin.x, y: y, width: r.size.width, height: r.size.height)
}

open class KCLayer: CALayer
{
	private var mDirtyRect		: CGRect

	public init(frame f: CGRect){
		mDirtyRect = CGRect.zero
		super.init()
		frame = f
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public var image: KGImage? {
		get {
			if let img = self.contents as? KGImage {
				return img
			} else {
				return nil
			}
		}

		set(newimg){
			self.contents = newimg?.toCGImage
		}
	}

	public func mouseEvent(event evt: KCMouseEvent, at point: CGPoint) {
		if let sublayers = self.sublayers {
			for sublayer in sublayers {
				if let l = sublayer as? KCLayer {
					l.mouseEvent(event: evt, at: point)
				}
			}
		}
	}

	public func observe(state s: CNState){
		if let sublayers = self.sublayers {
			for sublayer in sublayers {
				if let l = sublayer as? KCLayer {
					l.observe(state: s)
				}
			}
		}
	}

	open override func setNeedsDisplayIn(_ r: CGRect) {
		mDirtyRect = mDirtyRect.union(r)
		#if os(iOS)
			let convrect = convertCoodinate(sourceRect: mDirtyRect, bounds: bounds)
			super.setNeedsDisplayIn(convrect)
		#else
			super.setNeedsDisplayIn(mDirtyRect)
		#endif
	}
}

public enum KCLayerAction: String
{
	case onOrderIn	= "onOrderIn"
	case onOrderOut	= "onOrderOut"
	case onLayout	= "onLayout"
	case onDraw	= "onDraw"
	case sublayer	= "sublayer"
	case contents	= "contents"
	case bounds	= "bounds"
}

/*
open class KCLayer: CALayer, CALayerDelegate
{


	public init(frame frm: CGRect){
		let newbounds	= CGRect(origin: CGPoint.zero, size: frm.size)
		mDirtyRect	= newbounds
		super.init()

		super.delegate	= self

		frame		= frm
		bounds		= newbounds
		backgroundColor	= nil
	}

	public required init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}



	/* Method for delegate */
	public func draw(_ layer: CALayer, in context: CGContext) {
		context.saveGState()

		#if os(iOS)
			context.translateBy(x: 0.0, y: bounds.size.height)
			context.scaleBy(x: 1.0, y: -1.0)
		#endif
		drawContent(in: context)

		context.restoreGState()
		mDirtyRect = CGRect.zero
	}

	open func drawContent(in context: CGContext){
	}



	public func clearUpdateRect() {
		mDirtyRect = CGRect.zero
	}



	open func layerDescription() -> String {
		return "(bounds:\(bounds.description) frame:\(frame.description))"
	}
}
*/


