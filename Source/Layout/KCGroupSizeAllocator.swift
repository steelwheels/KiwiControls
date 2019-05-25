/**
 * @file	KCGroupSizeAllocator.swift
 * @brief	Define KCGroupSizeAllocator class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCGroupSizeAllocator: KCViewVisitor
{
	open override func visit(rootView view: KCRootView){
		let coreview: KCCoreView = view.getCoreView()
		coreview.accept(visitor: self)
	}

	open override func visit(stackView view: KCStackView){
		/* first visit subviews */
		for view in view.arrangedSubviews() {
			view.accept(visitor: self)
		}

		/* Allocate foreach groups */
		let axis      = view.axis
		let groups    = KCGroupMaker.makeGroups(stackView: view)
		var curbounds = mergeElementSizes(stackView: view)
		for group in groups {
			curbounds = allocate(group: group, axis: axis, in: curbounds)
		}
		view.resize(mergeElementSizes(stackView: view))
	}

	open override func visit(coreView view: KCCoreView){
		/* Do nothing */
	}

	private func allocate(group grp: Array<KCView>, axis axs: CNAxis, in bounds: KCSize) -> KCSize {
		/* Allocate for each views */
		var curbounds = bounds
		let views = sortedSubviews(subviews: grp, axis: axs)
		for view in views {
			/* Allocate view */
			view.accept(visitor: self)
			/* Resize bounds */
			curbounds = deleteSize(sizeA: curbounds, sizeB: view.frame.size, axis: axs)
		}
		/* Adjust each views */
		var newbounds = KCSize.zero
		switch axs {
		case .vertical:
			for view in grp {
				newbounds.width  =  max(newbounds.width, view.frame.size.width)
				newbounds.height += view.frame.size.height
			}
			for view in grp {
				view.frame.size.width  = newbounds.width
				view.bounds.size.width = newbounds.width
			}
		case .horizontal:
			for view in grp {
				newbounds.width  += view.frame.size.width
				newbounds.height  = max(newbounds.height, view.frame.size.height)
			}
			for view in grp {
				view.frame.size.height  = newbounds.height
				view.bounds.size.height = newbounds.height
			}
		}
		return newbounds
	}

	private func deleteSize(sizeA sa: KCSize, sizeB sb: KCSize, axis axs: CNAxis) -> KCSize {
		let result: KCSize
		switch axs {
		case .vertical:
			if sa.height > sb.height {
				result = KCSize(width: sa.width, height: sa.height - sb.height)
			} else {
				log(type: .Error, string: "Height underflow", file: #file, line: #line, function: #function)
				result = KCSize(width: sa.width, height: 0.0)
			}
		case .horizontal:
			if sa.width > sb.width {
				result = KCSize(width: sa.width - sb.height, height: sa.height)
			} else {
				log(type: .Error, string: "Width underflow", file: #file, line: #line, function: #function)
				result = KCSize(width: 0.0, height: sa.height)
			}
		}
		return result
	}

	private func mergeElementSizes(stackView stack: KCStackView) -> KCSize {
		var result: KCSize = KCSize.zero
		switch stack.axis {
		case .vertical:
			for subview in stack.arrangedSubviews() {
				result.width   = max(result.width, subview.frame.width)
				result.height += subview.frame.height
			}
		case .horizontal:
			for subview in stack.arrangedSubviews() {
				result.width  += subview.frame.width
				result.height  = max(result.height, subview.frame.height)
			}
		}
		return result
	}

	private func sortedSubviews(subviews views: Array<KCView>, axis axs: CNAxis) -> Array<KCView> {
		var result: Array<KCView> = []
		for priority in KCCoreView.ExpansionPriority.sortedPriorities() {
			for subview in views {
				if let coreview = subview as? KCCoreView {
					let (hexp, vexp) = coreview.expansionPriorities()
					if axs == .horizontal && hexp == priority {
						result.append(coreview)
					} else if axs == .vertical && vexp == priority {
						result.append(coreview)
					}
				} else {
					NSLog("[Error] Unknown view")
				}
			}
		}
		return result
	}
}

/*
public class KCGroupSizeAllocator: KCViewVisitor
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
		/* Do nothing */
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
		updateStackViewSize(stackView: view)
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
				log(type: .Error, string: "Not stack view", file: #file, line: #line, function: #function)
			}
		}
		guard subviews.count > 0 else {
			log(type: .Error, string: "Empty stack view", file: #file, line: #line, function: #function)
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
		for subview in subviews {
			updateStackViewSize(stackView: subview)
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

	private func updateStackViewSize(stackView view: KCStackView){
		var totalsize = KCSize.zero
		let dovert    = view.axis == .vertical
		for subview in view.arrangedSubviews() {
			totalsize = KCUnionSize(sizeA: totalsize, sizeB: subview.frame.size, doVertical: dovert)
		}
		view.resize(totalsize)
	}
}
*/


