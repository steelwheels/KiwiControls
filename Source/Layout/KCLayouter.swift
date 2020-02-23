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
	private var mConsole:		CNConsole

	public required init(console cons: CNConsole){
		mConsole	= cons
	}

	public var console: CNConsole? {
		get { return mConsole }
	}

	public func layout(rootView view: KCRootView, contentRect content: KCRect){
		log(type: .flow, string: "Get content size", file: #file, line: #line, function: #function)

		log(type: .flow, string: "Minimize content size: " + content.size.description, file: #file, line: #line, function: #function)
		let minimizer = KCSizeMinimizer(rootSize: content.size, console: mConsole)
		view.accept(visitor: minimizer)
		//dump(view: view)

		/*
		log(type: .flow, string: "Minimize group size", file: #file, line: #line, function: #function)
		let groupfitter = KCGroupSizeAllocator(console: mConsole)
		view.accept(visitor: groupfitter)
		//dump(view: view)
*/

		/*
		log(type: .flow, string: "Adjust view size", file: #file, line: #line, function: #function)
		let adjuster = KCSizeAdjuster(console: mConsole)
		view.accept(visitor: adjuster)
		//dump(view: view)
*/
		
		log(type: .flow, string: "Decide distribution", file: #file, line: #line, function: #function)
		let distdecider = KCDistributionDecider(console: mConsole)
		view.accept(visitor: distdecider)
		//dump(view: view)

		log(type: .flow, string: "Allocate root frame size", file: #file, line: #line, function: #function)
		let winupdator = KCWindowSizeUpdator(console: mConsole)
		winupdator.updateContentSize(rootView: view, contentRect: content)
		//dump(view: view)

		NSLog("Layout result size: \(view.frame.size.description)")
	}

	/*
	private class func safeAreaInset(viewController vcont: KCViewController) -> KCEdgeInsets {
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
*/
	private func dump(view v: KCView) {
		if let cons = console {
			let dumper = KCViewDumper(console: cons)
			dumper.dump(view: v)
		} else {
			NSLog("No console")
		}
	}
}

