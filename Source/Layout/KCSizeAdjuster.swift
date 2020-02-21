/**
 * @file	KCSizeAdjuster.swift
 * @brief	Define KCSizeAdjuster class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCSizeAdjuster: KCViewVisitor
{
	open override func visit(rootView view: KCRootView){
		let coreview: KCCoreView = view.getCoreView()
		coreview.accept(visitor: self)
	}

	open override func visit(stackView view: KCStackView){
		/* Visit child view */
		let subviews = view.arrangedSubviews()
		for subview in subviews {
			subview.accept(visitor: self)
		}
		/* If the stackview has only 1 subviews, adjust size of subviews */
		if subviews.count == 1 {
			subviews[0].resize(view.frame.size)
		}
	}

	open override func visit(labeledStackView view: KCLabeledStackView){
		view.contentsView.accept(visitor: self)
	}

	open override func visit(coreView view: KCCoreView){
	}
}

