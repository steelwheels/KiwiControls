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

public class KCImageDrawerLayer: KCLayer, CALayerDelegate
{
	private var mLayerDrawer:	KGImageDrawer
	private var mDrawnSize:		CGSize

	public init(frame f: CGRect, drawer d: @escaping KGImageDrawer){
		mLayerDrawer = d
		mDrawnSize   = CGSize.zero
		super.init(frame: f)
		super.delegate = self
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	//public func display(_ layer: CALayer) {
	//	Swift.print("display")
	//}

	public func draw(_ layer: CALayer, in ctx: CGContext) {
		//Swift.print("draw")
		let framesize = layer.frame.size
		var image: KGImage
		if let imgp = layer.contents as? KGImage {
			if framesize != mDrawnSize {
				layer.contents = image = drawImage(context: ctx, size: framesize)
				mDrawnSize = framesize
			} else {
				image = imgp
			}
		} else {
			layer.contents = image = drawImage(context: ctx, size: framesize)
			mDrawnSize = framesize
		}
		ctx.draw(image.toCGImage, in: layer.frame)
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

	/*
	public func layerWillDraw(_ layer: CALayer) {
		Swift.print("layerWilDraw")
		let framesize = layer.frame.size
		if (layer.contents == nil) || (framesize != mDrawnSize){
			Swift.print("* layerWilDraw *")

			let image = KGImage.generate(size: framesize, drawFunc: mLayerDrawer)
			layer.contents = image
			mDrawnSize = framesize
		}
	}


	public func action(for layer: CALayer, forKey event: String) -> CAAction? {
		Swift.print("action: \(event)")
		switch KCLayerAction(rawValue: event)! {
		case .onOrderIn:	Swift.print("* onOrderIn *")
		case .onOrderOut:	Swift.print("* onOrderOut *")
		case .onLayout:		Swift.print("* onLayout *")
		case .onDraw:		Swift.print("* onDraw *")
		case .sublayer:		Swift.print("* sublayer *")
		case .contents:		Swift.print("* contents *")
		case .bounds:		Swift.print("* bounds *")
		}
		return nil
	}
*/
}


