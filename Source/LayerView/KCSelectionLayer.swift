/**
 * @file	KCSelectionLayer.swift
 * @brief	Define KCSelectionLayer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import KiwiGraphics

public class KCSelectionLayer: KCLayer
{
	public static let	None: Int		= -1
	private var		mVisibleIndex: Int	= None

	public override func addSublayer(_ layer: CALayer) {
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

	public var visibleIndex: Int {
		get {
			return mVisibleIndex
		}
		set(idx){
			if let layers = self.sublayers {
				if mVisibleIndex != KCSelectionLayer.None {
					layers[mVisibleIndex].isHidden = true
				}
				if 0<=idx && idx<layers.count {
					layers[idx].isHidden = false
					mVisibleIndex = idx
				} else {
					mVisibleIndex = KCSelectionLayer.None
				}
			}
		}
	}
}

