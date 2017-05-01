/**
 * @file	KCCoreView.swift
 * @brief	Define KCCoreView class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation

open class KCCoreView: KCView
{
	private var mCoreView: KCView? = nil

	public func setCoreView(view v: KCView) {
		mCoreView = v
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
