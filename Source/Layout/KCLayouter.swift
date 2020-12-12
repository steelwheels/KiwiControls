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

	private func dump(logLevel level: CNConfig.LogLevel, phase str: String, view v: KCView) {
		if CNPreference.shared.systemPreference.logLevel.isIncluded(in: level) {
			if let cons = KCLogManager.shared.console {
				cons.print(string: str + "\n")
				let dumper = KCViewDumper()
				dumper.dump(view: v, console: cons)
			} else {
				NSLog("No console log at \(#function)")
			}
		}
	}
}

