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
	open override func contentCompressionResistancePriority(for orientation: NSLayoutConstraint.Orientation) -> NSLayoutConstraint.Priority
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
	open override func setContentCompressionResistancePriority(_ priority: NSLayoutConstraint.Priority, for orientation: NSLayoutConstraint.Orientation)
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
	open override func contentHuggingPriority(for orientation: NSLayoutConstraint.Orientation) -> NSLayoutConstraint.Priority
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
	open override func setContentHuggingPriority(_ priority: NSLayoutConstraint.Priority, for orientation: NSLayoutConstraint.Orientation) {
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

		public var description: String {
			get {
				var result: String
				switch self {
				case .HighPriority: result = "high"
				case .LowPriority:  result = "low"
				}
				return result
			}
		}
	}

	public func setPriorityToResistAutoResize(horizontalPriority hval: LayoutPriority, verticalPriority vval: LayoutPriority)
	{
		let hparam = decodePriority(priority: hval)
		let vparam = decodePriority(priority: vval)
		setContentCompressionResistancePriority(hparam, for: .horizontal)
		setContentCompressionResistancePriority(vparam, for: .vertical)
		setContentHuggingPriority(hparam, for: .horizontal)
		setContentHuggingPriority(vparam, for: .vertical)
	}

	#if os(OSX)
	private func decodePriority(priority value: LayoutPriority) -> NSLayoutConstraint.Priority
	{
		let parameter: NSLayoutConstraint.Priority
		switch value {
		case .HighPriority:	parameter = NSLayoutConstraint.Priority.defaultHigh
		case .LowPriority:	parameter = NSLayoutConstraint.Priority.defaultLow
		}
		return parameter
	}
	#else
	private func decodePriority(priority value: LayoutPriority) -> UILayoutPriority
	{
		let parameter: UILayoutPriority
		switch value {
		case .HighPriority:	parameter = .defaultHigh
		case .LowPriority:	parameter = .defaultLow
		}
		return parameter
	}
	#endif

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

	open override func printDebugInfo(indent idt: Int){
		super.printDebugInfo(indent: idt)
		if let v = mCoreView {
			v.printDebugInfo(indent: idt+1)
		}
	}
}
