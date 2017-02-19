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

public protocol KCDrawerLayerProtocol
{
	var  contentRect: CGRect { get }
	func move(dx: CGFloat, dy: CGFloat)
	func moveTo(x: CGFloat, y: CGFloat)
}

open class KCLayer: CALayer
{
	private var mUpdateRect:  CGRect

	public init(frame f: CGRect){
		mUpdateRect  = CGRect.zero
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

	open func mouseEvent(event evt: KCMouseEvent, at point: CGPoint) {
		if let sublayers = self.sublayers {
			for sublayer in sublayers {
				if let l = sublayer as? KCLayer {
					l.mouseEvent(event: evt, at: point)
				}
			}
		}
	}

	open func observe(state s: CNState){
		if let sublayers = self.sublayers {
			for sublayer in sublayers {
				if let l = sublayer as? KCLayer {
					l.observe(state: s)
				}
			}
		}
	}

	public func doUpdate(){
		if mUpdateRect.size.width > 0.0 && mUpdateRect.size.height > 0.0 {
			setNeedsDisplayIn(mUpdateRect)
			mUpdateRect = CGRect.zero
		}
		if let slayers = self.sublayers {
			for sublayer in slayers {
				if let l = sublayer as? KCLayer {
					if !l.isHidden {
						l.doUpdate()
					}
				}
			}
		}
	}

	public func requrestUpdateIn(dirtyRect drect: CGRect){
		mUpdateRect = mUpdateRect.union(drect)
	}

	open override func setNeedsDisplayIn(_ dirtyrect: CGRect) {
		#if os(iOS)
			let convrect = convertCoodinate(sourceRect: dirtyrect, bounds: bounds)
			super.setNeedsDisplayIn(convrect)
		#else
			super.setNeedsDisplayIn(dirtyrect)
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



