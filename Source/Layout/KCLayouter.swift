/**
 * @file	KCLayouter.swift
 * @brief	Define KCLayouter class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCLayouter
{
	private var mViewController:	KCSingleViewController
	private var mConsole:		CNConsole
	private var mDoVerbose:		Bool
	private var mDebug:		Bool

	public init(viewController vcont: KCSingleViewController, console cons: CNConsole, doVerbose doverb: Bool){
		mViewController = vcont
		mConsole	= cons
		mDoVerbose	= doverb
		mDebug		= false
	}

	public class func windowSize(viewController vcont: KCSingleViewController) -> KCSize {
		if let parent = vcont.parentController {
			let result: KCSize
			#if os(OSX)
			if let window = parent.view.window {
				result = window.entireFrame.size
			} else {
				CNLog(type: .Error, message: "No window", place: #file)
				result = KCSize(width: 100.0, height: 100.0)
			}
			#else
			result = UIScreen.main.bounds.size
			#endif
			return result
		} else {
			CNLog(type: .Error, message: "No parent controller", place: #file)
			return KCSize(width: 0.0, height: 0.0)
		}
	}

	public func layout(rootView view: KCRootView, windowSize winsize: KCSize){
		doDump(message: "/* Get content size */", view: view)
		let windowrect = KCRect(origin: CGPoint.zero, size: winsize)
		doLog(message: "//  windowsize:" + winsize.description)

		doDump(message: "Before size minimizer", view: view)
		let minimizer = KCSizeMinimizer()
		view.accept(visitor: minimizer)

		doDump(message: "Before group size allocator", view: view)
		let groupfitter = KCGroupSizeAllocator()
		view.accept(visitor: groupfitter)

		doDump(message: "Allocate frame size", view: view)
		let insets       = KCLayouter.safeAreaInset(viewController: mViewController)
		let frmallocator = KCFrameSizeAllocator(windowSize: winsize, windowInset: insets)
		frmallocator.setRootFrame(rootView: view, contentRect: windowrect)

		doDump(message: "Before distribution decider", view: view)
		let distdecider = KCDistributionDecider()
		view.accept(visitor: distdecider)
		
		doDump(message: "Result of layout passes", view: view)
	}

	private class func safeAreaInset(viewController vcont: KCSingleViewController) -> KCEdgeInsets {
		if let parent = vcont.parentController {
			let space = KCPreference.shared.layoutPreference.spacing
			#if os(OSX)
			let result = KCEdgeInsets(top: space, left: space, bottom: space, right: space)
			#else
			let topmargin: CGFloat
			if KCPreference.shared.layoutPreference.isPortrait {
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
			CNLog(type: .Error, message: "No parent controller", place: #file)
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

	private func doLog(message msg: String) {
		if mDoVerbose {
			mConsole.print(string: msg + "\n")
		}
	}

	private func doDump(message msg: String, view v: KCView){
		if mDebug {
			mConsole.print(string: "//////// \(msg)\n")
			let dumper = KCViewDumper(console: mConsole)
			dumper.dump(view: v)
		}
	}
}

