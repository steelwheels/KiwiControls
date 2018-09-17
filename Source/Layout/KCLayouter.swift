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
		let minimizer = KCSizeMinimizer()
		view.accept(visitor: minimizer)

		doDump(message: "Before group fitting", view: view)
		let groupfitter = KCGroupFitLayouter()
		view.accept(visitor: groupfitter)

		doDump(message: "Before frame allocation", view: view)
		let frmallocator = KCFrameAllocLayouter(viewController: mViewController, console: mConsole)
		view.accept(visitor: frmallocator)

		doDump(message: "Before updating intrinsic contents size", view: view)
		let sizeupdater = KCIntrisicSizeUpdater(viewController: mViewController)
		view.accept(visitor: sizeupdater)

		doDump(message: "Result of layout passes", view: view)
	}

	private func doDump(message msg: String, view v: KCView){
		if mDoVerbose {
			mConsole.print(string: "//////// \(msg)\n")
			let dumper = KCViewDumper(console: mConsole)
			dumper.dump(view: v)
		}
	}
}

