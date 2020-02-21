/**
 * @file	KCFrameSizeAllocator.swift
 * @brief	Define KCFrameSizeAllocator class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCWindowSizeUpdator: KCViewVisitor
{
	private var mContentRect:	KCRect
	private var mResultSize:	KCSize = KCSize.zero

	public init(contentRect content: KCRect, console cons: CNConsole) {
		mContentRect	= content
		super.init(console: cons)
	}

	open override func visit(rootView view: KCRootView){
		visit(coreView: view)

		NSLog("Merged size: \(mResultSize.description)")
		/* Allocate root frame */
		view.rebounds(origin: mContentRect.origin, size: mResultSize)
		/* Setup content view */
		if let core: KCCoreView = view.getCoreView() {
			core.rebounds(origin: mContentRect.origin, size: mResultSize)
		}
	}

	open override func visit(stackView view: KCStackView){
		var result: KCSize = KCSize.zero
		/* Visit children first */
		let subviews = view.arrangedSubviews()
		for subview in subviews {
			subview.accept(visitor: self)
			result = mergeSize(size0: result, size1: subview.frame.size, axis: view.axis)
		}
		/* Update size */
		mResultSize = result
	}

	open override func visit(labeledStackView view: KCLabeledStackView){
		view.contentsView.accept(visitor: self)
		mResultSize = view.sizeToContain(size: mResultSize)
	}

	private func mergeSize(size0 s0: KCSize, size1 s1: KCSize, axis ax: CNAxis) -> KCSize {
		let space = CNPreference.shared.windowPreference.spacing

		var width, height: CGFloat
		switch ax {
		case .horizontal:
			width  = s0.width + space + s1.width
			height = max(s0.height, s1.height)
		case .vertical:
			width  = max(s0.width, s1.width)
			height = s0.height + space + s1.height
		}
		return KCSize(width: width, height: height)
	}

	open override func visit(coreView view: KCCoreView){
		mResultSize = view.frame.size
	}
}

/*
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

*/

