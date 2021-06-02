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
		print(logLevel: .detail, message: "[Layout] Adjust expandability")
		let adjuster = KCExpansionAdjuster()
		view.accept(visitor: adjuster)
		dump(view: view)

		print(logLevel: .detail, message: "[Layout] Decide distribution")
		let distdecider = KCDistributionDecider()
		view.accept(visitor: distdecider)
		dump(view: view)
	}

	private func dump(view v: KCView) {
		if CNPreference.shared.systemPreference.logLevel.isIncluded(in: .detail) {
			let dumper = KCViewDumper()
			dumper.dump(view: v, console: CNLogManager.shared.console)
		}
	}

	private func print(logLevel level: CNConfig.LogLevel, message msg: String) {
		if CNPreference.shared.systemPreference.logLevel.isIncluded(in: level) {
			CNLog(logLevel: level, message: msg)
		}
	}
}

