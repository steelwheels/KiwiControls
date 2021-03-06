/**
 * @file	KCDistributionDecider.swift
 * @brief	Define KCDistributionDecider class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import Foundation

public class KCDistributionDecider: KCViewVisitor
{
	open override func visit(rootView view: KCRootView){
		let coreview: KCInterfaceView = view.getCoreView()
		coreview.accept(visitor: self)
	}

	open override func visit(stackView view: KCStackView){
		/* First, resize members */
		for subview in view.arrangedSubviews() {
			subview.accept(visitor: self)
		}
		/* Resize it self */
		decideDistribution(stackView: view)
	}

	open override func visit(labeledStackView view: KCLabeledStackView){
		view.contentsView.accept(visitor: self)
	}

	open override func visit(coreView view: KCInterfaceView){
		/* Do nothing */
	}

	private func decideDistribution(stackView view: KCStackView){
		let groups = KCGroupMaker.makeGroups(stackView: view)
		if groups.count <= 1 {
			view.distribution = .fillEqually
		} else {
			view.distribution = .fill
		}
	}
}

