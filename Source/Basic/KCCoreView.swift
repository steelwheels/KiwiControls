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

		public static func sortedPriorities() -> Array<ExpansionPriority> {
			return [.Fixed, .Low, .High]
		}

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

	open override var intrinsicContentSize: KCSize {
		get {
			if let core = mCoreView {
				return core.intrinsicContentSize
			} else {
				return super.intrinsicContentSize
			}
		}
	}

	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		let coreview: KCView = getCoreView()
		return coreview.sizeThatFits(size)
	}

	open override var fittingSize: KCSize {
		let coreview: KCView = getCoreView()
		return coreview.fittingSize
	}

	open override func resize(_ size: KCSize){
		if hasCoreView {
			let coreview: KCView = getCoreView()
			coreview.resize(size)
		}
		super.resize(size)
	}

	#if os(OSX)
	public override func becomeFirstResponder(for window: NSWindow) -> Bool {
		if hasCoreView {
			let coreview: KCView = getCoreView()
			return coreview.becomeFirstResponder(for: window)
		}
		return false
	}
	#endif

	open func expansionPriorities() -> (ExpansionPriority /* Holiz */, ExpansionPriority /* Vert */) {
		return (.Fixed, .Fixed)
	}

	#if os(OSX)
	public override func contentCompressionResistancePriority(for orientation: NSLayoutConstraint.Orientation) -> NSLayoutConstraint.Priority {
		switch contentPriorityForCore(forVertical: orientation == .vertical) {
		case .Fixed:	return .defaultHigh
		case .Low:	return .defaultHigh
		case .High:	return .defaultLow
		}
	}
	#else
	public override func contentCompressionResistancePriority(for axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
		switch contentPriorityForCore(forVertical: axis == .vertical) {
		case .Fixed:	return .defaultHigh
		case .Low:	return .defaultHigh
		case .High:	return .defaultLow
		}
	}
	#endif

	#if os(OSX)
	public override func contentHuggingPriority(for orientation: NSLayoutConstraint.Orientation) -> NSLayoutConstraint.Priority {
		switch contentPriorityForCore(forVertical: orientation == .vertical) {
		case .Fixed:	return .defaultHigh
		case .Low:	return .defaultHigh
		case .High:	return .defaultLow
		}
	}
	#else
	public override func contentHuggingPriority(for axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
		switch contentPriorityForCore(forVertical: axis == .vertical) {
		case .Fixed:	return .defaultHigh
		case .Low:	return .defaultHigh
		case .High:	return .defaultLow
		}
	}
	#endif

	private func contentPriorityForCore(forVertical dovert: Bool) -> ExpansionPriority {
		let (hpri, vpri) = self.expansionPriorities()
		if dovert {
			return vpri
		} else {
			return hpri
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
