/**
 * @file	KCSizeMinimizer.swift
 * @brief	Define KCSizeMinimizer class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCSizeMinimizer: KCViewVisitor
{
	private var mParentSize: KCSize = KCSize.zero
	private var mResultSize: KCSize = KCSize.zero

	open override func visit(rootView view: KCRootView){
		let coreview: KCCoreView = view.getCoreView()

		mParentSize = view.frame.size
		coreview.accept(visitor: self)
		coreview.resize(mResultSize)
	}

	open override func visit(coreView view: KCCoreView){
		mResultSize = view.sizeThatFits(mParentSize)
		view.resize(mResultSize)
	}
}

