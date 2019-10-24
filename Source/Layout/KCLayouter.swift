/**
 * @file	KCLayouter.swift
 * @brief	Define KCLayouter class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCLayouter: CNLogging
{
	private var mViewController:	KCSingleViewController
	private var mConsole:		CNConsole

	public required init(viewController vcont: KCSingleViewController, console cons: CNConsole){
		mViewController = vcont
		mConsole	= cons
	}

	public var console: CNConsole? {
		get { return mConsole }
	}

	public func layout(rootView view: KCRootView, windowSize winsize: KCSize){
		log(type: .flow, string: "Get content size", file: #file, line: #line, function: #function)
		let windowrect = KCRect(origin: CGPoint.zero, size: winsize)

		log(type: .flow, string: "Minimize window size: " + winsize.description, file: #file, line: #line, function: #function)
		let minimizer = KCSizeMinimizer(rootSize: winsize, console: mConsole)
		view.accept(visitor: minimizer)

		log(type: .flow, string: "Minimize group size", file: #file, line: #line, function: #function)
		let groupfitter = KCGroupSizeAllocator(console: mConsole)
		view.accept(visitor: groupfitter)

		log(type: .flow, string: "Allocate root frame size", file: #file, line: #line, function: #function)
		let insets       = KCLayouter.safeAreaInset(viewController: mViewController)
		let rootallocator = KCRootSizeAllocator(windowSize: winsize, windowInset: insets)
		rootallocator.setRootFrame(rootView: view, contentRect: windowrect)

		log(type: .flow, string: "Adjust view size", file: #file, line: #line, function: #function)
		let adjuster = KCSizeAdjuster(console: mConsole)
		view.accept(visitor: adjuster)

		log(type: .flow, string: "Decide distribution", file: #file, line: #line, function: #function)
		let distdecider = KCDistributionDecider(console: mConsole)
		view.accept(visitor: distdecider)
	}

	private class func safeAreaInset(viewController vcont: KCSingleViewController) -> KCEdgeInsets {
		let parent = vcont.parentController
		let space: CGFloat = CNPreference.shared.windowPreference.spacing
		#if os(OSX)
			let result = KCEdgeInsets(top: space, left: space, bottom: space, right: space)
		#else
			let topmargin: CGFloat
			if CNPreference.shared.windowPreference.isPortrait {
				topmargin =  16.0 - space
			} else {
				topmargin =  0.0
			}
			let insets = parent.view.safeAreaInsets
			let result = KCEdgeInsets(top:    insets.top    + topmargin + space,
						  left:   insets.left   + space,
						  bottom: insets.bottom + space,
						  right:  insets.right  + space)
		#endif
		return result
	}

	private class func contentRect(size sz: KCSize, inset ist: KCEdgeInsets) -> KCRect {
		let x      = ist.left
		let y      = ist.top
		let width  = max(0.0, sz.width  - (x + ist.right))
		let height = max(0.0, sz.height - (y + ist.bottom))
		return KCRect(x: x, y: y, width: width, height: height)
	}
}

