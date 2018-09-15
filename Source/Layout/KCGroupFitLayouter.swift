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
		let grouplist = getSameContents(stackView: view)
		for group in grouplist {
			let firstitem = group[0]

			/* Adjust contents in the elements */
			if let _ = firstitem as? KCStackView {
				adjustUnionSubviewSizes(group: group)
			}

			/* Adjust subviews */
			adjustUnionComponentSizes(components: group)
		}
		/* resize */
		view.sizeToFit()
	}

	private func getSameContents(stackView view: KCStackView) -> Array<Array<KCView>> {
		var result: Array<Array<KCView>> = []

		let contents = view.arrangedSubviews()
		if contents.count >= 2 {
			var srcs: Array<KCView> = contents
			while srcs.count > 0 {
				let src     			= srcs[0]
				let rests   			= srcs.dropFirst()
				var unusedsrcs: Array<KCView> 	= []
				var usedsrcs: Array<KCView> 	= [src]
				for rest in rests {
					if isSameComponent(componentA: src, componentB: rest) {
						usedsrcs.append(rest)
					} else {
						unusedsrcs.append(rest)
					}
				}
				if usedsrcs.count > 1 {
					result.append(usedsrcs)
				}
				srcs = unusedsrcs
			}
		}

		return result
	}

	/*
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
*/

	private func isSameComponent(componentA compa: KCView, componentB compb: KCView) -> Bool {
		var result: Bool = false
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
			result = (type(of: compa) == type(of: compb))
		}
		return result
	}

	private func adjustUnionSubviewSizes(group contents: Array<KCView>){
		/* Collect all subviews in stack as KCStackView */
		var subviews: Array<KCStackView> = []
		for subview in contents {
			if let stack = subview as? KCStackView {
				subviews.append(stack)
			} else {
				NSLog("\(#function) [Error] Not stack view")
			}
		}
		guard subviews.count > 0 else {
			NSLog("\(#function) [Error] Empty stack view")
			return
		}

		/* Resize items in subviews */
		let itemnum = subviews[0].arrangedSubviews().count
		for itemidx in 0..<itemnum {
			var subsubviews: Array<KCView> = []
			for subview in subviews {
				let subsubview = subview.arrangedSubviews()[itemidx]
				subsubviews.append(subsubview)
			}
			adjustUnionComponentSizes(components: subsubviews)
		}

		/* Resize subviews and it self */
		for subview in contents {
			subview.sizeToFit()
		}
	}

	private func adjustUnionComponentSizes(components views: Array<KCView>){
		/* Get unioned size */
		var usize = KCSize(width: 0.0, height: 0.0)
		for subview in views {
			usize = KCUnionSize(sizeA: usize, sizeB: subview.frame.size)
		}
		/* Resize them */
		for subview in views {
			subview.resize(usize)
		}
	}
}

