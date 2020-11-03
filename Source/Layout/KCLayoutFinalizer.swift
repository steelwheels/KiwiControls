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
	public func finalizeLayout(rootView view: KCRootView){
		CNLog(logLevel: .debug, message: "Frame size finalizer")
		let sizefinalizer = KCFrameSizeFinalizer()
		view.accept(visitor: sizefinalizer)
		//dump(view: view)
	}

	private func dump(view v: KCView) {
		let dumper = KCViewDumper()
		dumper.dump(view: v)
	}
}

