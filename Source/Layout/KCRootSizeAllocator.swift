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
	private var mWindowSize		: KCSize
	private var mWindowInset	: KCEdgeInsets

	public required init(windowSize winsize: KCSize, windowInset inset: KCEdgeInsets){
		mWindowSize 	= winsize
		mWindowInset	= inset
	}

	public func setRootFrame(rootView view: KCRootView, contentRect content: KCRect){
		/* Allocate root frame */
		view.rebounds(origin: content.origin, size: content.size)
		view.resize(content.size)

		/* Setup content view */
		if let core: KCCoreView = view.getCoreView() {
			/* Fix the size */
			core.resize(content.size.inset(by: mWindowInset))
			/* Allocate constraint */
			view.allocateSubviewLayout(subView: core, in: mWindowInset)
		}
	}
}


