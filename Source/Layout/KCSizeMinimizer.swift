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
	private var mRootSize:   KCSize

	public init(rootSize root: KCSize, console cons: CNConsole) {
		mRootSize = root
		super.init(console: cons)
	}

	open override func visit(rootView view: KCRootView){
		let coreview: KCCoreView = view.getCoreView()

		/* do not use resize */
		view.frame.size  = mRootSize
		view.bounds.size = mRootSize

		coreview.accept(visitor: self)
		coreview.resize(coreview.fittingSize)
	}

	open override func visit(stackView view: KCStackView){
		/* Visit children first */
		for subview in view.arrangedSubviews() {
			subview.accept(visitor: self)
		}
		view.resize(view.fittingSize)
	}

	open override func visit(labeledStackView view: KCLabeledStackView){
		view.contentsView.accept(visitor: self)
		view.resize(view.fittingSize)
	}

	open override func visit(coreView view: KCCoreView){
		view.resize(view.fittingSize)
	}
}

