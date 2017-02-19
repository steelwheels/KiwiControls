/**
 * @file	KCSelectionLayer.swift
 * @brief	Define KCSelectionLayer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import KiwiGraphics

open class KCSelectionLayer: KCLayer, KCDrawerLayerProtocol
{
	public static let	None: Int		= -1
	private var		mVisibleIndex: Int	= None

	open override func addSublayer(_ layer: CALayer) {
		layer.frame	= self.frame
		layer.isHidden	= true
		super.addSublayer(layer)
	}

	public var count: Int {
		get {
			if let layers = self.sublayers {
				return layers.count
			} else {
				return 0
			}
		}
	}

	public var contentRect: CGRect {
		get { return frame }
	}

	public var visibleIndex: Int {
		get {
			return mVisibleIndex
		}
		set(idx){
			if let layers = self.sublayers {
				if mVisibleIndex != KCSelectionLayer.None {
					if let l = layers[mVisibleIndex] as? KCLayer {
						l.isHidden = true
						l.requrestUpdateIn(dirtyRect: l.frame)
					} else {
						fatalError("Invalid object")
					}
				}
				if 0<=idx && idx<layers.count {
					if let l = layers[idx] as? KCLayer {
						l.isHidden = false
						l.requrestUpdateIn(dirtyRect: l.frame)
					} else {
						fatalError("Invalid object")
					}
					mVisibleIndex = idx
				} else {
					mVisibleIndex = KCSelectionLayer.None
				}
			}
		}
	}

	public func move(dx xval: CGFloat, dy yval: CGFloat) {
		if let subs = self.sublayers {
			for layer in subs {
				if let drawer = layer as? KCDrawerLayerProtocol {
					drawer.move(dx: xval, dy: yval)
				}
			}
		}
	}

	public func moveTo(x xval: CGFloat, y yval: CGFloat) {
		if let subs = self.sublayers {
			for layer in subs {
				if let drawer = layer as? KCDrawerLayerProtocol {
					drawer.moveTo(x: xval, y: yval)
				}
			}
		}
	}
}

