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
		KCView.setAutolayoutMode(views: [self, mLayerView, mLabelView])
		
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

	open override var fittingSize: KCSize {
		get {
			#if os(OSX)
			let labsize = mLabelView.fittingSize
			let imgsize = mLayerView.fittingSize
			#else
			let labsize = mLabelView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
			let imgsize = mLayerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
			#endif
			let space   = CNPreference.shared.windowPreference.spacing
			return KCUnionSize(sizeA: labsize, sizeB: imgsize, doVertical: true, spacing: space)
		}
	}

	open override var intrinsicContentSize: KCSize {
		get {
			if hasFixedSize {
				return super.intrinsicContentSize
			} else {
				let layersize = mLayerView.intrinsicContentSize
				let labelsize = mLabelView.intrinsicContentSize
				let space     = CNPreference.shared.windowPreference.spacing
				return KCUnionSize(sizeA: layersize, sizeB: labelsize, doVertical: true, spacing: space)
			}
		}
	}

	public override func setExpandability(holizontal holiz: KCViewBase.ExpansionPriority, vertical vert: KCViewBase.ExpansionPriority) {
		mLayerView.setExpansionPriority(holizontal: holiz, vertical: vert)
		mLabelView.setExpansionPriority(holizontal: .Fixed, vertical: .Fixed)
		super.setExpandability(holizontal: holiz, vertical: vert)
	}

	open override func resize(_ size: KCSize) {
		let imgsize = mLayerView.frame.size
		let labsize: KCSize
		if imgsize.width < size.width {
			labsize = KCSize(width: size.width - imgsize.width, height: size.height)
		} else {
			log(type: .error, string: "Too short size", file: #file, line: #line, function: #function)
			labsize = KCSize(width: 1.0, height: size.height)
		}
		mLabelView.frame.size         = labsize
		mLabelView.bounds.size        = labsize
		mLayerView.frame.size.height  = size.height
		mLayerView.bounds.size.height = size.height
		super.resize(size)
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

