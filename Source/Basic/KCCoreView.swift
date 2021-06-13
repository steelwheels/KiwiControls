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

	public override func requireLayout() {
		super.requireLayout()
		if let core = mCoreView {
			core.requireLayout()
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

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		if let core = mCoreView {
			core.invalidateIntrinsicContentSize()
		}
	}

	#if os(OSX)
	public override var acceptsFirstResponder: Bool { get {
		if let core = mCoreView {
			return core.acceptsFirstResponder
		} else {
			return false
		}
	}}
	#endif

	public override func becomeFirstResponder() -> Bool {
		if let core = mCoreView {
			return core.becomeFirstResponder()
		} else {
			return false
		}
	}

	open override func setExpandabilities(priorities prival: KCViewBase.ExpansionPriorities) {
		if let core = mCoreView {
			core.setExpandabilities(priorities: prival)
		}
		super.setExpandabilities(priorities: prival)
	}

	open override func setFrameSize(_ newsize: KCSize) {
		if let core = mCoreView {
			core.setFrameSize(newsize)
		}
		super.setFrameSize(newsize)
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
				core.isHidden   = !newval
			}
		}
	}
}
