/**
 * @file	KCImageDrawerLayer.swift
 * @brief	Define KCImageDrawerLayer class
 * @par Copyright
 *   Copyright (C) 2016-2017 Steel Wheels Project
 */

import Foundation
import CoreGraphics
import KiwiGraphics
#if os(iOS)
  import UIKit
#else
  import Cocoa
#endif

open class KCImageDrawerLayer: KCLayer, KCDrawerLayerProtocol, CALayerDelegate
{
	private var mDrawRect:		CGRect
	private var mLayerDrawer:	KGImageDrawer
	private var mDrawnSize:		CGSize

	public init(frame frm: CGRect, drawRect drect: CGRect, drawer drw: @escaping KGImageDrawer){
		mDrawRect = drect
		mLayerDrawer = drw
		mDrawnSize   = CGSize.zero
		super.init(frame: frm)
		super.delegate = self
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	//public func display(_ layer: CALayer) {
	//	Swift.print("display")
	//}

	public func move(dx xval: CGFloat, dy yval: CGFloat) {
		mDrawRect = mDrawRect.move(dx: xval, dy: yval)
	}

	public func moveTo(x xval: CGFloat, y yval:CGFloat){
		mDrawRect.origin = CGPoint(x: xval, y: yval)
	}

	public func draw(_ layer: CALayer, in ctx: CGContext) {
		//Swift.print("draw")
		let drawsize = mDrawRect.size
		var image: KGImage
		if let imgp = layer.contents as? KGImage {
			if drawsize != mDrawnSize {
				layer.contents = image = drawImage(context: ctx, size: drawsize)
				mDrawnSize = drawsize
			} else {
				image = imgp
			}
		} else {
			layer.contents = image = drawImage(context: ctx, size: drawsize)
			mDrawnSize = drawsize
		}
		let drawrect = layer.frame.move(dx: mDrawRect.origin.x, dy: mDrawRect.origin.y)
		ctx.draw(image.toCGImage, in: drawrect)
	}

	private func drawImage(context ctx:CGContext, size sz:CGSize) -> KGImage {
		let image: KGImage
		#if os(iOS)
			ctx.saveGState()
			ctx.translateBy(x: 0.0, y: bounds.size.height)
			ctx.scaleBy(x: 1.0, y: -1.0)
			image = KGImage.generate(context: ctx, size: sz, drawFunc: mLayerDrawer)
			ctx.restoreGState()
		#else
			image = KGImage.generate(context: ctx, size: sz, drawFunc: mLayerDrawer)
		#endif
		return image
	}
}


