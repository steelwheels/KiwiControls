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

	public override func set(console cons: CNConsole?) {
		if let core = mCoreView {
			core.set(console: cons)
		}
		super.set(console: cons)
	}

	/* for autolayout */
	public enum ExpansionPriority {
		case High
		case Low
		case Fixed
		public func description() -> String {
			let result: String
			switch self {
			case .High:	result = "high"
			case .Low:	result = "low"
			case .Fixed:	result = "fixed"
			}
			return result
		}
	}

	public var fixedSize: KCSize? {
		get {
			return mFixedSize
		}
		set(newsize){
			mFixedSize = newsize
		}
	}

	open func expansionPriorities() -> (ExpansionPriority /* Holiz */, ExpansionPriority /* Vert */) {
		return (.Fixed, .Fixed)
	}

	open override func resize(_ size: KCSize){
		if hasCoreView {
			let coreview: KCView = getCoreView()
			coreview.resize(size)
		}
		super.resize(size)
	}

	open override func sizeToFit() {
		let coreview: KCView = getCoreView()
		coreview.sizeToFit()
		super.resize(coreview.frame.size)
	}

	open override var intrinsicContentSize: KCSize {
		get {
			if let s = mFixedSize {
				return s
			} else if let v = mCoreView {
				return v.intrinsicContentSize
			} else {
				return KCSize(width: KCView.noIntrinsicValue, height: KCView.noIntrinsicValue)
			}
		}
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
}
