/**
 * @file	KCCoreView.swift
 * @brief	Define KCCoreView class
 * @par Copyright
 *   Copyright (C) 2017-2020 Steel Wheels Project
 */

import Foundation
import CoconutData
#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif

open class KCCoreView: KCView
{
	private var mCoreView:	KCView? = nil

	public func setCoreView(view v: KCView) {
		mCoreView = v
		self.addSubview(v)
	}

	public var hasCoreView: Bool {
		if let _ = mCoreView {
			return true
		} else {
			return false
		}
	}

	public func getCoreView<T>() -> T {
		if let v = mCoreView as? T {
			return v
		} else {
			fatalError("No core view")
		}
	}

	open override var intrinsicContentSize: KCSize {
		get {
			if let core = mCoreView {
				return core.intrinsicContentSize
			} else {
				return super.intrinsicContentSize
			}
		}
	}

	open override var fittingSize: KCSize {
		let coreview: KCView = getCoreView()
		return coreview.fittingSize
	}

	open override func expandability() -> (KCViewBase.ExpansionPriority, KCViewBase.ExpansionPriority) {
		if let core = mCoreView {
			return core.expandability()
		} else {
			return super.expandability()
		}
	}
	open override func setExpandability(holizontal holiz: KCViewBase.ExpansionPriority, vertical vert: KCViewBase.ExpansionPriority) {
		if let core = mCoreView {
			core.setExpandability(holizontal: holiz, vertical: vert)
		}
		super.setExpandability(holizontal: holiz, vertical: vert)
	}

	open override func resize(_ size: KCSize){
		if hasCoreView {
			let coreview: KCView = getCoreView()
			coreview.resize(size)
		}
		super.resize(size)
	}

	public var isVisible: Bool {
		get {
			if let core = mCoreView {
				return !(core.isHidden)
			} else {
				fatalError("\(#function) [Error] No core view")
			}
		}
		set(newval){
			if let core = mCoreView {
				CNExecuteInMainThread(doSync: false, execute: { () -> Void in
					core.isHidden   = !newval
				})
			}
		}
	}
}
