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
		dump(phase: "[SizeMinizer]", view: view)

		CNLog(logLevel: .debug, message: "Adjust expandability ")
		let adjuster = KCExpansionAdjuster()
		view.accept(visitor: adjuster)
		dump(phase: "[Adjust expandability]", view: view)

		CNLog(logLevel: .debug, message: "Decide distribution")
		let distdecider = KCDistributionDecider()
		view.accept(visitor: distdecider)
		dump(phase: "[Decide distribution]", view: view)

		CNLog(logLevel: .debug, message: "Allocate root frame size")
		let winupdator = KCWindowSizeUpdator()
		winupdator.updateContentSize(rootView: view, contentSize: content)
		dump(phase: "[Root size allocation]", view: view)

		CNLog(logLevel: .debug, message: "Expand size of elements in the stack")
		let expander = KCElementSizeExpander(parentSize: content)
		view.accept(visitor: expander)
		dump(phase: "[Element size expansion]", view: view)
	}

	private func dump(phase str: String, view v: KCView) {
		CNLog(logLevel: .debug, message: "Result of \(str)")
		let dumper = KCViewDumper()
		dumper.dump(view: v)
	}
}

