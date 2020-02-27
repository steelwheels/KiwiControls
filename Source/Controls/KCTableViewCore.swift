/**
 * @file	KCTableViewCore.swift
 * @brief	Define KCTableViewCore class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif

open class KCTableViewCore : KCView
{
	#if os(OSX)
	@IBOutlet weak var mTableView: NSTableView!
	#else
	@IBOutlet weak var mTableView: UITableView!
	#endif

	public func setup(frame frm: CGRect) {
		KCView.setAutolayoutMode(views: [self, mTableView])
		self.rebounds(origin: KCPoint.zero, size: frm.size)
	}

	open override var fittingSize: KCSize {
		#if os(OSX)
			return mTableView.fittingSize
		#else
			return mTableView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		#endif
	}

	open override var intrinsicContentSize: KCSize {
		get {
			if hasFixedSize {
				return super.intrinsicContentSize
			} else {
				return mTableView.intrinsicContentSize
			}
		}
	}
	
	open override func resize(_ size: KCSize) {
		mTableView.frame.size  = size
		mTableView.bounds.size = size
		super.resize(size)
	}
}

