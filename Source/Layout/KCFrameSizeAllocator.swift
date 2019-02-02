/**
 * @file	KCFrameSizeAllocator.swift
 * @brief	Define KCFrameSizeAllocator class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCFrameSizeAllocator
{
	private var mWindowSize		: KCSize
	private var mWindowInset	: KCEdgeInsets

	public init(windowSize winsize: KCSize, windowInset inset: KCEdgeInsets){
		mWindowSize 	= winsize
		mWindowInset	= inset
	}

	public func setRootFrame(rootView view: KCRootView, contentRect content: KCRect){
		/* Allocate root frame */
		view.frame	= content
		view.bounds	= KCRect(origin: KCPoint.zero, size: content.size)
		view.fixedSize  = content.size

		/* Setup content view */
		if let core: KCCoreView = view.getCoreView() {
			/* Fix the size */
			core.fixedSize = content.size.inset(by: mWindowInset)
			/* Allocate constraint */
			view.allocateSubviewLayout(subView: core, in: mWindowInset)
		}
	}
}


