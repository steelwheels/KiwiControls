/**
 * @file	KCCoreView.swift
 * @brief	Define KCCoreView class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation
#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif

open class KCCoreView: KCView
{
	private var mCoreView: KCView? = nil

	public func setCoreView(view v: KCView) {
		mCoreView = v
	}

	open override var intrinsicContentSize: KCSize {
		get {
			if let v = mCoreView {
				return v.intrinsicContentSize
			} else {
				return KCSize(width: -1.0, height: -1.0)
			}
		}
	}

	#if os(OSX)
	open override func contentCompressionResistancePriority(for orientation: NSLayoutConstraintOrientation) -> NSLayoutPriority
	{
		if let core = mCoreView {
			return core.contentCompressionResistancePriority(for: orientation)
		} else {
			return super.contentCompressionResistancePriority(for: orientation)
		}
	}
	#else
	open override func contentCompressionResistancePriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority {
		if let core = mCoreView {
			return core.contentCompressionResistancePriority(for:axis)
		} else {
			return super.contentCompressionResistancePriority(for: axis)
		}
	}
	#endif

	#if os(OSX)
	open override func setContentCompressionResistancePriority(_ priority: NSLayoutPriority, for orientation: NSLayoutConstraintOrientation)
	{
		if let core = mCoreView	 {
			core.setContentCompressionResistancePriority(priority, for: orientation)
		}
		super.setContentCompressionResistancePriority(priority, for: orientation)
	}
	#else
	open override func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: UILayoutConstraintAxis) {
		if let core = mCoreView {
			core.setContentCompressionResistancePriority(priority, for: axis)
		}
		super.setContentCompressionResistancePriority(priority, for: axis)
	}
	#endif

	#if os(OSX)
	open override func contentHuggingPriority(for orientation: NSLayoutConstraintOrientation) -> NSLayoutPriority
	{
		if let core = mCoreView {
			return core.contentHuggingPriority(for: orientation)
		} else {
			return super.contentHuggingPriority(for: orientation)
		}
	}
	#else
	open override func contentHuggingPriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority {
		if let core = mCoreView {
			return core.contentHuggingPriority(for: axis)
		} else {
			return super.contentHuggingPriority(for: axis)
		}
	}
	#endif

	#if os(OSX)
	open override func setContentHuggingPriority(_ priority: NSLayoutPriority, for orientation: NSLayoutConstraintOrientation) {
		if let core = mCoreView {
			core.setContentHuggingPriority(priority, for: orientation)
		}
		super.setContentHuggingPriority(priority, for: orientation)
	}
	#else
	open override func setContentHuggingPriority(_ priority: UILayoutPriority, for axis: UILayoutConstraintAxis) {
		if let core = mCoreView {
			core.setContentHuggingPriority(priority, for: axis)
		}
		super.setContentHuggingPriority(priority, for: axis)
	}
	#endif

	public enum LayoutPriority {
		case HighPriority
		case LowPriority
	}

	public func setPriorityToResistAutoResize(priority value: LayoutPriority) {
		#if os(OSX)
			let parameter: NSLayoutPriority
			switch value {
			case .HighPriority:	parameter = NSLayoutPriorityDefaultHigh
			case .LowPriority:	parameter = NSLayoutPriorityDefaultLow
			}
		#else
			let parameter: UILayoutPriority
			switch value {
			case .HighPriority:	parameter = UILayoutPriorityDefaultLow
			case .LowPriority:	parameter = UILayoutPriorityDefaultLow
			}
		#endif
		setContentCompressionResistancePriority(parameter, for: .horizontal)
		setContentCompressionResistancePriority(parameter, for: .vertical)
		setContentHuggingPriority(parameter, for: .horizontal)
		setContentHuggingPriority(parameter, for: .vertical)
	}

	public func getCoreView<T>() -> T {
		if let v = mCoreView as? T {
			return v
		} else {
			fatalError("No core view")
		}
	}

	open override func printDebugInfo(indent idt: Int){
		super.printDebugInfo(indent: idt)
		if let v = mCoreView {
			v.printDebugInfo(indent: idt+1)
		}
	}
}
