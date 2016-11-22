/**
 * @file	KCLayer.swift
 * @brief	Define KCLayer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import KiwiGraphics
import CoreGraphics
import Cocoa

open class KCLayer: CALayer
{
	public init(frame frm: CGRect){
		super.init()
		frame  = frm
		bounds = CGRect(origin: CGPoint.zero, size: frm.size)
	}

	public required init?(coder decoder: NSCoder) {
		let b = decoder.decodeRect()
		super.init(coder: decoder)
		bounds = b
	}

	public var image: NSImage? {
		get {
			if let img = self.contents as? NSImage {
				return img
			} else {
				return nil
			}
		}

		set(newimg){
			self.contents = newimg
		}
	}

	open func mouseEvent(event evt: KCMouseEvent, at point: CGPoint) -> CGRect {
		var result: CGRect = CGRect.zero
		/* Visit subviews */
		if let sublayers = self.sublayers {
			for sublayer in sublayers {
				if let l = sublayer as? KCLayer {
					let urect = l.mouseEvent(event: evt, at: point)
					if !urect.isEmpty {
						result = result.union(urect)
					}
				}
			}
		}
		return result
	}

	open func layerDescription() -> String {
		return "(bounds:\(bounds.description) frame:\(frame.description))"
	}
}
