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

	public init(viewController vcont: KCSingleViewController, console cons: CNConsole, doVerbose doverb: Bool){
		mViewController = vcont
		mConsole	= cons
		mDoVerbose	= doverb
	}

	public func layout(rootView view: KCRootView){
		doDump(message: "Before size fitting", view: view)
		let sizefitter = KCSizeFitLayouter()
		view.accept(visitor: sizefitter)

		doDump(message: "Before group fitting", view: view)
		let groupfitter = KCGroupFitLayouter()
		view.accept(visitor: groupfitter)

		doDump(message: "Before frame allocation", view: view)
		let frmallocator = KCFrameAllocLayouter(viewController: mViewController, console: mConsole)
		view.accept(visitor: frmallocator)
	}

	private func doDump(message msg: String, view v: KCView){
		if mDoVerbose {
			mConsole.print(string: "//////// \(msg)\n")
			let dumper = KCViewDumper(console: mConsole)
			dumper.dump(view: v)
		}
	}
}

