/**
 * @file	KCImageDrawerLayer.swift
 * @brief	Define KCImageDrawerLayer class
 * @par Copyright
 *   Copyright (C) 2016-2017 Steel Wheels Project
 */


import CoconutData
#if os(iOS)
  import UIKit
#else
  import Cocoa
#endif
import Foundation
import CoreGraphics

open class KCImageDrawerLayer: KCLayer, KCDrawerLayerProtocol, CALayerDelegate
{
	private var mContentRect:	CGRect
	private var mImageDrawer:	KCImageDrawer? = nil
	private var mDrawnSize:		CGSize

	public init(frame frm: CGRect, contentRect crect: CGRect){
		mContentRect  = crect
		mDrawnSize    = CGSize.zero
		super.init(frame: frm)
		super.delegate = self
		self.requrestUpdateIn(dirtyRect: frm)
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public var imageDrawer: KCImageDrawer? {
		get { return mImageDrawer }
		set(drawer) { mImageDrawer = drawer }
	}

	public var contentRect: CGRect {
		get { return mContentRect }
	}

	public override func updateLayout(frame f: CGRect){
		super.updateLayout(frame: f)
		mContentRect = mContentRect.intersection(f)
	}

	public func move(dx xval: CGFloat, dy yval: CGFloat) {
		requrestUpdateIn(dirtyRect: mContentRect)
		mContentRect.origin.x += xval
		mContentRect.origin.y += yval
		requrestUpdateIn(dirtyRect: mContentRect)
	}

	public func moveTo(x xval: CGFloat, y yval: CGFloat) {
		requrestUpdateIn(dirtyRect: mContentRect)
		mContentRect.origin.x = xval
		mContentRect.origin.y = yval
		requrestUpdateIn(dirtyRect: mContentRect)
	}

	//public func display(_ layer: CALayer) {
	//	Swift.print("display")
	//}

	public func draw(_ layer: CALayer, in ctx: CGContext) {
		if let drawer = mImageDrawer {
			let contentsize = mContentRect.size
			var image: CNImage
			if let imgp = layer.contents as? CNImage {
				if contentsize != mDrawnSize {
					layer.contents = image = drawImage(context: ctx, bounds: mContentRect, drawer: drawer)
					mDrawnSize = contentsize
				} else {
					image = imgp
				}
			} else {
				layer.contents = image = drawImage(context: ctx, bounds: mContentRect, drawer: drawer)
				mDrawnSize = contentsize
			}
			let drawrect = mContentRect.move(dx: frame.origin.x, dy: frame.origin.y)
			ctx.draw(image.toCGImage, in: drawrect)
		}
	}

	private func drawImage(context ctx:CGContext, bounds bnds:CGRect, drawer drw: KCImageDrawer) -> CNImage {
		let image: CNImage
		#if os(iOS)
			ctx.saveGState()
			ctx.translateBy(x: 0.0, y: bounds.size.height)
			ctx.scaleBy(x: 1.0, y: -1.0)
			image = CNImage.generate(context: ctx, bounds: bnds, drawFunc: drw)
			ctx.restoreGState()
		#else
			image = CNImage.generate(context: ctx, bounds: bnds, drawFunc: drw)
		#endif
		return image
	}
}


