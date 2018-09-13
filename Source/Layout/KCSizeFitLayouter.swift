/**
 * @file	KCSizeFitLayouter.swift
 * @brief	Define KCSizeFitLayouter class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCSizeFitLayouter: KCViewVisitor
{
	open override func visit(rootView view: KCRootView){
		let coreview: KCCoreView = view.getCoreView()
		coreview.accept(visitor: self)
	}

	open override func visit(stackView view: KCStackView){
		/* First, resize members */
		for subview in view.arrangedSubviews() {
			subview.accept(visitor: self)
		}
		/* Next resize it self */
		view.sizeToFit()
	}

	open override func visit(coreView view: KCCoreView){
		view.sizeToFit()
	}
}

