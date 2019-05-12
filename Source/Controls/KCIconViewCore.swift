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
import CoconutData

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

	public func setup(frame frm: CGRect) {
		self.rebounds(origin: KCPoint.zero, size: frm.size)

		let layerframe   = KCIconViewCore.calcLayerFrame(entireFrame: bounds, deltaHeight: mLabelView.frame.size.height)
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

	open override func sizeToFit() {
		mLayerView.sizeToFit()
		mLabelView.sizeToFit()
		let coresize = KCUnionSize(sizeA: mLayerView.frame.size, sizeB: mLabelView.frame.size, doVertical: true)
		super.resize(coresize)
	}

	public var imageDrawer: KCImageDrawer? {
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
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					#if os(OSX)
						myself.mLabelView.stringValue = str
					#elseif os(iOS)
						myself.mLabelView.text = str
					#endif
				}
			})
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

	open override var intrinsicContentSize: KCSize {
		get {
			let layersize = mLayerView.intrinsicContentSize
			let labelsize = mLabelView.intrinsicContentSize
			return KCUnionSize(sizeA: layersize, sizeB: labelsize, doVertical: true)
		}
	}
}

