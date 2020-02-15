/**
 * @file	KCFrameSizeAllocator.swift
 * @brief	Define KCFrameSizeAllocator class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCRootSizeAllocator
{
	public func setRootFrame(rootView view: KCRootView, contentRect content: KCRect){
		NSLog("Content rect: \(content.description)")

		/* Allocate root frame */
		view.rebounds(origin: content.origin, size: content.size)
		/* Setup content view */
		if let core: KCCoreView = view.getCoreView() {
			core.rebounds(origin: content.origin, size: content.size)
		}
	}
}


