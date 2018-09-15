/**
 * @file	KCGroupFitLayouter.swift
 * @brief	Define KCGroupFitLayouter class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import Foundation

public class KCGroupFitLayouter: KCViewVisitor
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
		/* Resize it self */
		fitForGroup(stackView: view)
	}

	open override func visit(coreView view: KCCoreView){
		view.sizeToFit()
	}

	private func fitForGroup(stackView view: KCStackView){
		if hasSameContents(stackView: view) {
			#if false
			let subviews  = view.arrangedSubviews()
			if let _ = subviews[0] as? KCStackView {
				fitForSubSubViews(in: view)
			} else {
				fitForSubviews(in: view)
			}
			#endif
		}
	}

	private func hasSameContents(stackView stack: KCStackView) -> Bool {
		let count = stack.arrangedSubviews().count
		var result: Bool
		switch count {
		case 0:
			result = false
		case 1:
			result = true
		default: // count > 1
			var issame = true
			let subviews  = stack.arrangedSubviews()
			let firstview = subviews[0]
			for subidx in 1..<count {
				if !isSameComponent(componentA: firstview, componentB: subviews[subidx]) {
					issame = false
					break
				}
			}
			result = issame
		}
		return result
	}

	private func isSameComponent(componentA compa: KCView, componentB compb: KCView) -> Bool {
		var result: Bool = false
		if type(of: compa) == type(of: compb) {
			if let stacka = compa as? KCStackView, let stackb = compb as? KCStackView {
				let childrena = stacka.arrangedSubviews()
				let childrenb = stackb.arrangedSubviews()
				if childrena.count == childrenb.count {
					var issame = true
					for i in 0..<childrena.count {
						if !isSameComponent(componentA: childrena[i], componentB: childrenb[i]) {
							issame = false
							break
						}
					}
					result = issame
				}
			} else {
				result = true
			}
		}
		return result
	}

	#if false
	private func fitForSubSubViews(in stack: KCStackView) {

	}

	private func fitForSubviews(in stack: KCStackView) {
		/* Get union size for all elements */
		let elms  = stack.arrangedSubviews()
		var usize = KCSize(width: 0.0, height: 0.0)
		for elm in elms {
			usize = KCUnionSize(sizeA: usize, sizeB: elm.frame.size)
		}
		/* Assign unipn sizes */
		for elm in elms {
		}
	}
	#endif
}

