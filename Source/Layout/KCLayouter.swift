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

	public class func windowSize(viewController vcont: KCSingleViewController, console cons: CNConsole) -> KCSize {
		if let parent = vcont.parentController {
			let result: KCSize
			#if os(OSX)
			if let window = parent.view.window {
				result = window.entireFrame.size
			} else {
				cons.error(string: "No window at \(#file)/\(#line)/\(#function)")
				result = KCSize(width: 100.0, height: 100.0)
			}
			#else
			result = UIScreen.main.bounds.size
			#endif
			return result
		} else {
			cons.error(string: "No parent controller at \(#file)/\(#line)/\(#function)")
			return KCSize(width: 0.0, height: 0.0)
		}
	}

	public func layout(rootView view: KCRootView, windowSize winsize: KCSize){
		log(type: .Flow, string: "Get content size", file: #file, line: #line, function: #function)
		let windowrect = KCRect(origin: CGPoint.zero, size: winsize)

		log(type: .Flow, string: "Minimize window size: " + winsize.description, file: #file, line: #line, function: #function)
		let minimizer = KCSizeMinimizer(console: mConsole)
		view.accept(visitor: minimizer)

		log(type: .Flow, string: "Minimize group size", file: #file, line: #line, function: #function)
		let groupfitter = KCGroupSizeAllocator(console: mConsole)
		view.accept(visitor: groupfitter)

		log(type: .Flow, string: "Allocate frame size", file: #file, line: #line, function: #function)
		let insets       = KCLayouter.safeAreaInset(viewController: mViewController)
		let frmallocator = KCFrameSizeAllocator(windowSize: winsize, windowInset: insets)
		frmallocator.setRootFrame(rootView: view, contentRect: windowrect)

		log(type: .Flow, string: "Decide distribution", file: #file, line: #line, function: #function)
		let distdecider = KCDistributionDecider(console: mConsole)
		view.accept(visitor: distdecider)
	}

	private class func safeAreaInset(viewController vcont: KCSingleViewController) -> KCEdgeInsets {
		if let parent = vcont.parentController {
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
		} else {
			NSLog("No parent controller")
			return KCEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
		}
	}

	private class func contentRect(size sz: KCSize, inset ist: KCEdgeInsets) -> KCRect {
		let x      = ist.left
		let y      = ist.top
		let width  = max(0.0, sz.width  - (x + ist.right))
		let height = max(0.0, sz.height - (y + ist.bottom))
		return KCRect(x: x, y: y, width: width, height: height)
	}
}

