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
	private var mCoreView:	KCViewBase? = nil

	public func setup(coreView cview: KCViewBase){
		mCoreView = cview
	}
}

