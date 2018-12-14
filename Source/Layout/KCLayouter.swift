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

	public func layout(rootView view: KCRootView){
		let windowsize = KCLayouter.windowSize(viewController: mViewController)
		let insets     = KCLayouter.safeAreaInset(viewController: mViewController)

		doDump(message: "Before size minimizer", view: view)
		let minimizer = KCSizeMinimizer()
		view.accept(visitor: minimizer)

		doDump(message: "Before group size allocator", view: view)
		let groupfitter = KCGroupSizeAllocator()
		view.accept(visitor: groupfitter)

		doDump(message: "Before frame allocation", view: view)
		let frmallocator = KCFrameSizeAllocator(windowSize: windowsize, windowInset: insets)
		frmallocator.setRootFrame(rootView: view)

		doDump(message: "Before distribution decider", view: view)
		let distdecider = KCDistributionDecider()
		view.accept(visitor: distdecider)
		
		doDump(message: "Result of layout passes", view: view)
	}

	private class func windowSize(viewController vcont: KCSingleViewController) -> KCSize {
		if let parent = vcont.parentController {
			let result: KCSize
			#if os(OSX)
			if let window = parent.view.window {
				result = window.entireFrame.size
			} else {
				NSLog("\(#function) [Error] No window")
				result = KCSize(width: 100.0, height: 100.0)
			}
			#else
			result = UIScreen.main.bounds.size
			#endif
			return result
		} else {
			NSLog("\(#function) [Error] No parent controller")
			return KCSize(width: 0.0, height: 0.0)
		}
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
			NSLog("\(#function) [Error] No parent controller")
			return KCEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
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

