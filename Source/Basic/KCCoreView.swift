/**
 * @file	KCCoreView.swift
 * @brief	Define KCCoreView class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
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
	private var mFixedSize:	KCSize?	= nil

	public func setCoreView(view v: KCView) {
		mCoreView = v
	}

	public var fixedSize: KCSize? {
		get {
			return mFixedSize
		}
		set(newsize){
			mFixedSize = newsize
		}
	}

	open override var intrinsicContentSize: KCSize {
		get {
			if let s = mFixedSize {
				return s
			} else if let v = mCoreView {
				return v.intrinsicContentSize
			} else {
				return KCSize(width: KCView.noIntrinsicMetric, height: KCView.noIntrinsicMetric)
			}
		}
	}

	public func setResizePriority(doGrowHolizontally holiz: Bool, doGrowVertically vert: Bool){
		if let core = mCoreView	 {
			if holiz {
				core.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
			} else {
				core.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
			}
			core.setContentHuggingPriority(.defaultLow, for: .horizontal)

			if vert {
				core.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
			} else {
				core.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
			}
			core.setContentHuggingPriority(.defaultLow, for: .vertical)
		}
	}

	public var isVisible: Bool {
		get {
			if let core = mCoreView {
				return !(core.isHidden)
			} else {
				fatalError("No core view")
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

	public func getCoreView<T>() -> T {
		if let v = mCoreView as? T {
			return v
		} else {
			fatalError("No core view")
		}
	}
}
