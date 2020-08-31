/**
 * @file	KCLayoutFinalizer.swift
 * @brief	Define KCLayoutFinalizer class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCLayoutFinalizer
{
	public init(){
	}

	public func finalizeLayout(window win: KCWindow, rootView view: KCRootView){
		CNLog(logLevel: .debug, message: "Frame size finalizer")
		let sizefinalizer = KCFrameSizeFinalizer()
		view.accept(visitor: sizefinalizer)

		#if os(OSX)
			let decider = KCFirstResponderDecider(window: win)
			let _ = decider.decideFirstResponder(rootView: view)
		#endif
		//dump(view: view)
	}

	private func dump(view v: KCView) {
		let dumper = KCViewDumper()
		dumper.dump(view: v)
	}
}

