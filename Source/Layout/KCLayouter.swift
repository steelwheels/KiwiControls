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
	public init(){
	}

	public func layout(rootView view: KCRootView){
		CNLog(logLevel: .debug, message: "Adjust expandability ")
		let adjuster = KCExpansionAdjuster()
		view.accept(visitor: adjuster)
		//dump(phase: "[Adjust expandability]", view: view)

		CNLog(logLevel: .debug, message: "Decide distribution")
		let distdecider = KCDistributionDecider()
		view.accept(visitor: distdecider)
		//dump(phase: "[Decide distribution]", view: view)
	}

	private func dump(phase str: String, view v: KCView) {
		CNLog(logLevel: .debug, message: "Result of \(str)")
		let dumper = KCViewDumper()
		dumper.dump(view: v)
	}
}

