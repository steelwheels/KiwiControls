/**
 * @file	KCFrameSizeAllocator.swift
 * @brief	Define KCFrameSizeAllocator class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCWindowSizeUpdator
{
	public init() {
	}

	public func updateContentSize(rootView root: KCRootView, contentSize content: KCSize) {
		root.rebounds(origin: root.frame.origin, size: content)
		if let core: KCView = root.getCoreView() {
			core.rebounds(origin: core.frame.origin, size: content)
		}
	}
}

