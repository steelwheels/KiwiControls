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

	public func layout(rootView view: KCRootView, contentSize content: KCSize){
		log(type: .flow, string: "Get content size", file: #file, line: #line, function: #function)

		log(type: .flow, string: "Minimize content size: " + content.description, file: #file, line: #line, function: #function)
		let minimizer = KCSizeMinimizer(rootSize: content, console: mConsole)
		view.accept(visitor: minimizer)
		//dump(view: view)

		log(type: .flow, string: "Adjust expandability ", file: #file, line: #line, function: #function)
		let adjuster = KCExpansionAdjuster(console: mConsole)
		view.accept(visitor: adjuster)
		
		log(type: .flow, string: "Decide distribution", file: #file, line: #line, function: #function)
		let distdecider = KCDistributionDecider(console: mConsole)
		view.accept(visitor: distdecider)
		//dump(view: view)

		log(type: .flow, string: "Allocate root frame size", file: #file, line: #line, function: #function)
		let winupdator = KCWindowSizeUpdator(console: mConsole)
		winupdator.updateContentSize(rootView: view, contentSize: content)
	}

	private func dump(view v: KCView) {
		if let cons = console {
			let dumper = KCViewDumper(console: cons)
			dumper.dump(view: v)
		} else {
			NSLog("No console")
		}
	}
}

