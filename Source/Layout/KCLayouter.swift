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

	public func layout(rootView view: KCRootView, contentSize content: KCSize){
		CNLog(logLevel: .debug, message: "Get content size: Minimize content size: " + content.description)

		let minimizer = KCSizeMinimizer(rootSize: content)
		view.accept(visitor: minimizer)
		//dump(view: view)

		CNLog(logLevel: .debug, message: "Adjust expandability ")
		let adjuster = KCExpansionAdjuster()
		view.accept(visitor: adjuster)

		CNLog(logLevel: .debug, message: "Decide distribution")
		let distdecider = KCDistributionDecider()
		view.accept(visitor: distdecider)
		//dump(view: view)

		CNLog(logLevel: .debug, message: "Allocate root frame size")
		let winupdator = KCWindowSizeUpdator()
		winupdator.updateContentSize(rootView: view, contentSize: content)
	}

	private func dump(view v: KCView) {
		let dumper = KCViewDumper()
		dumper.dump(view: v)
	}
}

