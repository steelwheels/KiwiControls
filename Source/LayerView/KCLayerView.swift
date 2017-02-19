/**
 * @file	KCLayerView.swift
 * @brief	Define KCLayerView class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import KiwiGraphics



public class KCLayerView: KCView
{
	public var rootLayer: CALayer {
		get {
			#if os(OSX)
				/* for OSX */
				if let root = self.layer {
					return root
				} else {
					let newlayer = KCLayer(frame: bounds)
					self.layer   = newlayer
					return newlayer
				}
			#else
				/* for iOS */
				return self.layer
			#endif
		}
	}

	public override func observe(state stat: CNState) {
		if let rootlayers = rootLayer.sublayers {
			for rootlayer in rootlayers {
				if let target = rootlayer as? KCLayer {
					target.observe(state: stat)
				}
			}
		}
	}

	public override func acceptMouseEvent(mouseEvent event:KCMouseEvent, mousePosition position:CGPoint){
		if let rootlayers = rootLayer.sublayers {
			for rootlayer in rootlayers {
				if let target = rootlayer as? KCLayer {
					//Swift.print(" -> position:\(position.description)")
					target.mouseEvent(event: event, at: position)
				}
			}
		}
	}
}


