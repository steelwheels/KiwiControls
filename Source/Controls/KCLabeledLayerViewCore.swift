/**
 * @file	KCLabeledLayerViewCore.swift
 * @brief	Define KCLabeledLayerViewCore class
 * @par Copyright
 *   Copyright (C) 017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCLabeledLayerViewCore : KCView
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
		KCView.setAutolayoutMode(views: [self, mLayerView, mLabelView])

		let layerframe   = KCLabeledLayerViewCore.calcLayerFrame(entireFrame: bounds, deltaHeight: mLabelView.frame.size.height)
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

	open override func setFrameSize(_ newsize: KCSize) {
		super.setFrameSize(newsize)
		let totalheight = newsize.height
		var labelheight = mLabelView.frame.height
		var layerheight = totalheight - labelheight
		if layerheight < 0.0 {
			labelheight = totalheight / 2.0
			layerheight = totalheight / 2.0
		}
		#if os(OSX)
			mLayerView.setFrameSize(KCSize(width: newsize.width, height: layerheight))
			mLabelView.setFrameSize(KCSize(width: newsize.width, height: labelheight))
		#else
			mLayerView.setFrameSize(size: KCSize(width: newsize.width, height: layerheight))
			mLabelView.setFrameSize(size: KCSize(width: newsize.width, height: labelheight))
		#endif
	}

	open override var intrinsicContentSize: KCSize {
		get {
			let layersize = mLayerView.intrinsicContentSize
			let labelsize = mLabelView.intrinsicContentSize
			let space     = CNPreference.shared.windowPreference.spacing
			return KCUnionSize(sizeA: layersize, sizeB: labelsize, doVertical: true, spacing: space)
		}
	}

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		mLayerView.invalidateIntrinsicContentSize()
		mLabelView.invalidateIntrinsicContentSize()
	}

	public override func setExpandabilities(priorities prival: KCViewBase.ExpansionPriorities) {
		mLayerView.setExpansionPriorities(priorities: prival)
		mLabelView.setExpansionPriorities(priorities: prival)
		super.setExpandabilities(priorities: prival)
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
}

