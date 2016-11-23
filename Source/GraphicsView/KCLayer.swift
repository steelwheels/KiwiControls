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
	private var mDirtyRect: CGRect

	public init(frame frm: CGRect){
		let newbounds = CGRect(origin: CGPoint.zero, size: frm.size)
		mDirtyRect = newbounds
		super.init()
		frame      = frm
		bounds     = newbounds
	}

	public required init?(coder decoder: NSCoder) {
		let newbounds = decoder.decodeRect()
		mDirtyRect = newbounds
		super.init(coder: decoder)
		frame  = newbounds
		bounds = newbounds
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

	open override func draw(in context: CGContext) {
		super.draw(in: context)
		mDirtyRect = CGRect.zero
	}

	open override func setNeedsDisplayIn(_ r: CGRect) {
		mDirtyRect = mDirtyRect.union(r)
		super.setNeedsDisplayIn(mDirtyRect)
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

	open func layerDescription() -> String {
		return "(bounds:\(bounds.description) frame:\(frame.description))"
	}
}
