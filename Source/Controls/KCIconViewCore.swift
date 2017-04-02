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
	#if os(OSX)
	@IBOutlet weak var mLayerView: KCLayerView!
	@IBOutlet weak var mLabelView: NSTextField!
	#elseif os(iOS)
	@IBOutlet weak var mLayerView: KCLayerView!
	@IBOutlet weak var mLabelView: UILabel!
	#endif

	private var mIconDrawer: KCImageDrawerLayer? = nil

	public func setup() {
		let layerframe   = KCIconViewCore.calcLayerFrame(entireFrame: frame, deltaHeight: mLabelView.frame.size.height)
		let layercontent = CGRect(origin: CGPoint.zero, size: layerframe.size)
		let drawer  = KCImageDrawerLayer(frame: layerframe, contentRect: layercontent)
		mLayerView.rootLayer.addSublayer(drawer)
		mIconDrawer = drawer
	}

	public class func calcLayerFrame(entireFrame ef: CGRect, deltaHeight dh: CGFloat) -> CGRect {
		let layersize = CGSize(width: ef.size.width, height: ef.size.height - dh)
		let layerorigin: CGPoint
		#if os(iOS)
			layerorigin = ef.origin
		#elseif os(OSX)
			layerorigin = CGPoint(x: ef.origin.x, y: ef.origin.y + dh)
		#endif
		return CGRect(origin: layerorigin, size: layersize)
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
			#if os(OSX)
				mLabelView.stringValue = str
			#elseif os(iOS)
				mLabelView.text = str
			#endif
		}
		get {
			#if os(OSX)
				return mLabelView.stringValue
			#elseif os(iOS)
				if let text = mLabelView.text {
					return text
				} else {
					return ""
				}
			#endif
		}
	}
}

