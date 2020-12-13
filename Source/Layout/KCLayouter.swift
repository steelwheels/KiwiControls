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
	private var mConsole:	CNConsole?

	public init(console cons: CNConsole?){
		mConsole = cons
	}

	public func layout(rootView view: KCRootView){
		print(logLevel: .debug, message: "[Layout] Adjust expandability")
		let adjuster = KCExpansionAdjuster()
		view.accept(visitor: adjuster)
		dump(view: view)

		print(logLevel: .debug, message: "[Layout] Decide distribution")
		let distdecider = KCDistributionDecider()
		view.accept(visitor: distdecider)
		dump(view: view)
	}

	private func dump(view v: KCView) {
		if CNPreference.shared.systemPreference.logLevel.isIncluded(in: .detail) {
			if let cons = mConsole {
				let dumper = KCViewDumper()
				dumper.dump(view: v, console: cons)
			}
		}
	}

	private func print(logLevel level: CNConfig.LogLevel, message msg: String) {
		if CNPreference.shared.systemPreference.logLevel.isIncluded(in: level) {
			if let cons = mConsole {
				cons.print(string: msg + "\n")
			} else {
				CNLog(logLevel: level, message: msg)
			}
		}
	}
}

