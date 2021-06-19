/**
 * @file	KCInterfaceView.swift
 * @brief	Define KCInterfaceView class
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

open class KCInterfaceView: KCView
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

	#if os(OSX)
	open override var canBecomeKeyView: Bool {
		get {
			if let core = mCoreView {
				return core.canBecomeKeyView
			} else {
				return super.canBecomeKeyView
			}
		}
	}

	open override var needsPanelToBecomeKey: Bool {
		get {
			if let core = mCoreView {
				return core.needsPanelToBecomeKey
			} else {
				return super.needsPanelToBecomeKey
			}
		}
	}

	open override var nextKeyView: NSView? {
		get {
			if let core = mCoreView {
				return core.nextKeyView
			} else {
				return super.nextKeyView
			}
		}
		set(newval){
			if let core = mCoreView {
				core.nextKeyView = newval
			} else {
				super.nextKeyView = newval
			}
		}
	}

	open override var nextValidKeyView: NSView? {
		get {
			if let core = mCoreView {
				return core.nextValidKeyView
			} else {
				return super.nextValidKeyView
			}
		}
	}

	open override var previousKeyView: NSView? {
		get {
			if let core = mCoreView {
				return core.previousKeyView
			} else {
				return super.previousKeyView
			}
		}
	}

	open override var previousValidKeyView: NSView? {
		get {
			if let core = mCoreView {
				return core.previousValidKeyView
			} else {
				return super.previousValidKeyView
			}
		}
	}
	#endif

	#if os(OSX)
	open override var needsLayout: Bool {
		get {
			if let core = mCoreView {
				return core.needsLayout
			} else {
				return super.needsLayout
			}
		}
		set(newval){
			if let core = mCoreView {
				core.needsLayout = newval
				super.needsLayout = newval
			} else {
				super.needsLayout = newval
			}
		}
	}
	#else
	open override func setNeedsLayout() {
		if let core = mCoreView {
			core.setNeedsLayout()
			super.setNeedsLayout()
		} else {
			super.setNeedsLayout()
		}
	}
	#endif

	#if os(OSX)
	open override var needsUpdateConstraints: Bool {
		get {
			if let core = mCoreView {
				return core.needsUpdateConstraints
			} else {
				return super.needsUpdateConstraints
			}
		}
		set(newval){
			if let core = mCoreView {
				core.needsUpdateConstraints  = newval
				super.needsUpdateConstraints = newval
			} else {
				super.needsUpdateConstraints = newval
			}
		}
	}
	#endif
	
	#if os(OSX)
	open override var needsDisplay: Bool {
		get {
			if let core = mCoreView {
				return core.needsDisplay
			} else {
				return super.needsDisplay
			}
		}
		set(newval){
			if let core = mCoreView {
				core.needsDisplay = newval
				super.needsDisplay = newval
			} else {
				super.needsDisplay = newval
			}
		}
	}
	#else
	open override func setNeedsDisplay() {
		if let core = mCoreView {
			core.setNeedsDisplay()
			super.setNeedsDisplay()
		} else {
			super.setNeedsDisplay()
		}
	}
	#endif

	open override func setFrameSize(_ newsize: KCSize) {
		if let core = mCoreView {
			core.setFrameSize(newsize)
		}
		super.setFrameSize(newsize)
	}

	#if os(OSX)
	open override var fittingSize: KCSize {
		get {
			if let core = mCoreView {
				return core.fittingSize
			} else {
				return super.fittingSize
			}
		}
	}
	#else
	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		if let core = mCoreView {
			return core.sizeThatFits(size)
		} else {
			return super.sizeThatFits(size)
		}
	}
	#endif

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

	open override func setExpandabilities(priorities prival: KCViewBase.ExpansionPriorities) {
		if let core = mCoreView {
			core.setExpandabilities(priorities: prival)
		}
		super.setExpandabilities(priorities: prival)
	}
}
