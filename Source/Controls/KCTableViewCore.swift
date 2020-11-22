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
	}

	open override var intrinsicContentSize: KCSize {
		get { return mTableView.intrinsicContentSize }
	}

	public override func setExpandability(holizontal holiz: KCViewBase.ExpansionPriority, vertical vert: KCViewBase.ExpansionPriority) {
		mTableView.setExpansionPriority(holizontal: holiz, vertical: vert)
		super.setExpandability(holizontal: holiz, vertical: vert)
	}
}

