/**
 * @file	KCIconViewCore.swift
 * @brief	Define KCIconViewCore class
 * @par Copyright
 *   Copyright (C) 017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import KiwiGraphics

open class KCIconViewCore : KCView
{
	@IBOutlet weak var mLayerView: KCLayerView!
	@IBOutlet weak var mLabelView: NSTextField!
	private var mIconDrawer: KCImageDrawerLayer? = nil

	public func setup() {
		let content = CGRect(origin: CGPoint.zero, size: frame.size)
		let drawer  = KCImageDrawerLayer(frame: frame, contentRect: content)
		mLayerView.rootLayer.addSublayer(drawer)
		mIconDrawer = drawer
	}

	public var imageDrawer: KGImageDrawer? {
		get {
			if let icondrawer = mIconDrawer {
				return icondrawer.imageDrawer
			} else {
				return nil
			}
		}
		set(drawer) {
			if let icondrawer = mIconDrawer {
				icondrawer.imageDrawer = drawer
				/* Redraw by new drawer */
				icondrawer.requrestUpdateIn(dirtyRect: frame)
				mLayerView.doUpdate()
			}
		}
	}

	public var label: String {
		set(str){
			mLabelView.stringValue = str
		}
		get {
			return mLabelView.stringValue
		}
	}
}

