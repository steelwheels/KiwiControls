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

	public func setRootFrame(rootView view: KCRootView){
		/* Allocate root frame */
		let frame	= KCRect(origin: KCPoint.zero, size: mWindowSize)
		view.frame	= frame
		view.bounds	= frame
		view.fixedSize	= frame.size
		//view.translatesAutoresizingMaskIntoConstraints = false

		/* Setup content view */
		if let core: KCView = view.getCoreView() {
			/* Allocate constraint */
			view.allocateSubviewLayout(subView: core, in: mWindowInset)
		}
	}
}


