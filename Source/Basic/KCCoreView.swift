/**
 * @file	KCCoreView.swift
 * @brief	Define KCCoreView class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import Foundation
#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif

open class KCCoreView: KCView
{
	private var mIsSingleView: Bool 	= false
	private var mCoreView: KCViewBase?	= nil

	public func setup(isSingleView single: Bool, coreView cview: KCViewBase){
		mIsSingleView	= single
		mCoreView	= cview
	}

	public override func setFrameSize(_ newsize: KCSize) {
		if mIsSingleView {
			if let core = mCoreView {
				#if os(OSX)
					core.setFrameSize(newsize)
				#else
					core.setFrameSize(size: newsize)
				#endif
			}
		}
		super.setFrameSize(newsize)
	}

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		if let core = mCoreView {
			core.invalidateIntrinsicContentSize()
		}
	}
}

