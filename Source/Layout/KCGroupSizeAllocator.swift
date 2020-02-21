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

	open override func visit(labeledStackView view: KCLabeledStackView){
		/* first visit subviews */
		view.contentsView.accept(visitor: self)
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
				log(type: .warning, string: "Height underflow", file: #file, line: #line, function: #function)
				result = KCSize(width: sa.width, height: 0.0)
			}
		case .horizontal:
			if sa.width > sb.width {
				result = KCSize(width: sa.width - sb.height, height: sa.height)
			} else {
				log(type: .warning, string: "Width underflow", file: #file, line: #line, function: #function)
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


