/**
 * @file	KCLayoutFinalizer.swift
 * @brief	Define KCLayoutFinalizer class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCLayoutFinalizer: CNLogging
{
	private var mConsole:		CNConsole

	public required init(console cons: CNConsole){
		mConsole	= cons
	}

	public var console: CNConsole? {
		get { return mConsole }
	}

	public func finalizeLayout(window win: KCWindow, rootView view: KCRootView){
		log(type: .flow, string: "Frame size finalizer", file: #file, line: #line, function: #function)
		let sizefinalizer = KCFrameSizeFinalizer(console: mConsole)
		view.accept(visitor: sizefinalizer)

		#if os(OSX)
			let decider = KCFirstResponderDecider(window: win, console: mConsole)
			let _ = decider.decideFirstResponder(rootView: view)
		#endif
		//dump(view: view)
	}

	private func dump(view v: KCView) {
		let dumper = KCViewDumper(console: mConsole)
		dumper.dump(view: v)
	}
}

