/**
 * @file	KCImageLayer.swift
 * @brief	Define KCImageLayer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import Cocoa
import KiwiGraphics

#if os(iOS)
	public typealias KCColor = UIColor
#else
	public typealias KCColor = NSColor
#endif

open class KCImageLayer: KCGraphicsLayer
{
	private var mCanvas:		KGImage
	private var mCanvasCache:	CGImage? = nil

	public init(bounds b: CGRect, backgroundColor bgc: KCColor){
		mCanvas = KGImage(size: b.size)
		mCanvas.backgroundColor = bgc
		mCanvasCache = nil
		super.init(bounds: b)
	}

	public override func drawContent(context ctxt:CGContext, bounds bnd:CGRect, dirtyRect drect:CGRect){
		//ctxt.draw(canvasCache, in: bnd)
	}

	private var canvasCache: CGImage {
		if let cache = mCanvasCache {
			return cache
		} else {
			let newcache = mCanvas.toCGImage
			mCanvasCache = newcache
			return newcache
		}
	}
}
