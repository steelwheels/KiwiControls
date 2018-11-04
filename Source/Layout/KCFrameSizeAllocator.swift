/**
 * @file	KCFrameSizeAllocator.swift
 * @brief	Define KCFrameSizeAllocator class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

private struct KCPrioritizeComponents {
	public var	highComponents	: Array<KCCoreView>
	public var	lowComponents	: Array<KCCoreView>
	public var	fixedComponents	: Array<KCCoreView>

	public init(){
		highComponents	= []
		lowComponents	= []
		fixedComponents	= []
	}
}

public class KCFrameSizeAllocator: KCViewVisitor
{
	private var mWindowSize		: KCSize
	private var mWindowInset	: KCEdgeInsets
	private var mCurrentFrames	: CNStack<KCRect>

	public init(windowSize winsize: KCSize, windowInset inset: KCEdgeInsets){
		mWindowSize 	= winsize
		mWindowInset	= inset
		mCurrentFrames	= CNStack()

		/* Push window frame */
		mCurrentFrames.push(KCRect(origin: KCPoint.zero, size: winsize))
	}

	open override func visit(rootView view: KCRootView){
		if let frame = mCurrentFrames.peek() {
			/* Allocate root frame */
			view.frame     = frame
			view.bounds    = frame
			view.fixedSize = frame.size
			view.translatesAutoresizingMaskIntoConstraints = true

			/* Setup content view */
			if let core: KCView = view.getCoreView() {
				/* Allocate constraint */
				view.allocateSubviewLayout(subView: core, in: mWindowInset)
				/* Allocate core frame */
				let cframe = KCEdgeInsetsInsetRect(frame, mWindowInset)
				mCurrentFrames.push(cframe)
				core.accept(visitor: self)
				let _ = mCurrentFrames.pop()
			}
		} else {
			fatalError("\(#function): Can not happen")
		}
	}

	open override func visit(stackView view: KCStackView){
		allocateFrameSize(stackView: view, doVertical: view.alignment.isVertical)
	}

	open override func visit(coreView view: KCCoreView) {
		if let frame = mCurrentFrames.peek() {
			let viewsize = view.frame.size
			let width    = max(frame.size.width,  viewsize.width)
			let height   = max(frame.size.height, viewsize.height)
			let newsize  = KCSize(width: width, height: height)
			view.resize(newsize)
		} else {
			fatalError("\(#function): Can not happen")
		}
	}

	private func allocateFrameSize(stackView view: KCStackView, doVertical dovert: Bool) {
		let components = prioritiesComponents(stackView: view, doVertical: dovert)
		if let frame = mCurrentFrames.peek() {
			var totallength     = lengthOfFrame(frame: frame, doVertical: dovert)

			/* Allocate fixed component */
			totallength = allocateFixedSizeComponents(components: components.fixedComponents,
								  parentFrame: frame,
								  totalLength: totallength,
								  doVertical: dovert)
			if components.highComponents.count > 0 {
				/* Allocate low priority components */
				totallength = allocateFixedSizeComponents(components: components.lowComponents,
									  parentFrame: frame,
									  totalLength: totallength,
									  doVertical: dovert)
				/* Allocate high priority components */
				allocateVariableSizeComponents(components: components.highComponents,
							       parentFrame: frame,
							       totalLength: totallength,
							       doVertical: dovert)
			} else {
				/* Allocate low priority components */
				allocateVariableSizeComponents(components: components.lowComponents,
							       parentFrame: frame,
							       totalLength: totallength,
							       doVertical: dovert)
			}
		} else {
			fatalError("\(#function): Can not happen")
		}
	}

	private func lengthOfSize(size sz: KCSize, doVertical dovert: Bool) -> CGFloat {
		return dovert ? sz.height : sz.width
	}

	private func lengthOfFrame(frame frm: KCRect, doVertical dovert: Bool) -> CGFloat {
		return lengthOfSize(size: frm.size, doVertical: dovert)
	}

	private func makeFrame(parentFrame parent: KCRect, length len: CGFloat, doVertical dovert: Bool) -> KCRect {
		let size: KCSize
		if dovert {
			size = KCSize(width: parent.size.width, height: len)
		} else {
			size = KCSize(width: len, height: parent.size.height)
		}
		return KCRect(origin: parent.origin, size: size)
	}

	private func allocateFixedSizeComponents(components comps: Array<KCCoreView>, parentFrame pframe: KCRect, totalLength total: CGFloat, doVertical dovert: Bool) -> CGFloat {
		var result = total
		for comp in comps {
			/* Allocate component frame */
			let complen   = lengthOfFrame(frame: comp.frame, doVertical: dovert)
			let compframe = makeFrame(parentFrame: pframe, length: complen, doVertical: dovert)
			mCurrentFrames.push(compframe)
			comp.accept(visitor: self)
			let _ = mCurrentFrames.pop()
			/* Update rest length */
			result = result >= complen ? result - complen : 0.0
		}
		return result
	}

	private func allocateVariableSizeComponents(components comps: Array<KCCoreView>, parentFrame pframe: KCRect, totalLength total: CGFloat, doVertical dovert: Bool) {
		if comps.count < 1 {
			return
		}
		/* get minimum length */
		var minlen: CGFloat = 0.0
		for comp in comps {
			minlen = minlen + lengthOfFrame(frame: comp.frame, doVertical: dovert)
		}
		/* get expandable spaces */
		let spaces: CGFloat
		if total - minlen > 0.0 {
			spaces = (total - minlen) / CGFloat(comps.count)
		} else {
			spaces = 0.0
		}
		for comp in comps {
			/* Allocate component frame */
			let complen   = lengthOfFrame(frame: comp.frame, doVertical: dovert)
			let compframe = makeFrame(parentFrame: pframe, length: complen + spaces, doVertical: dovert)
			mCurrentFrames.push(compframe)
			comp.accept(visitor: self)
			let _ = mCurrentFrames.pop()
		}
	}

	private func prioritiesComponents(stackView view: KCStackView, doVertical dovert: Bool) -> KCPrioritizeComponents {
		var result = KCPrioritizeComponents()
		for subview in view.arrangedSubviews() {
			if let subview = subview as? KCCoreView {
				let (hpri, vpri) = subview.expansionPriorities()
				let pri = dovert ? vpri : hpri
				switch pri {
				case .High:	result.highComponents.append(subview)
				case .Low:	result.lowComponents.append(subview)
				case .Fixed:	result.fixedComponents.append(subview)
				}
			} else {
				NSLog("\(#function) [Error] Unexpected view type")
			}
		}
		return result
	}
}


