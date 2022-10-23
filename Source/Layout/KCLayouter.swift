/**
 * @file	KCLayouter.swift
 * @brief	Define KCLayouter class
 * @par Copyright
 *   Copyright (C) 2015-2022 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCLayouter
{
	public init(){
	}

	public func layout(rootView view: KCRootView){
		CNLog(logLevel: .detail, message: "[Layout] Adjust expandability")
		let adjuster = KCExpansionAdjuster()
		view.accept(visitor: adjuster)

		CNLog(logLevel: .detail, message: "[Layout] Decide distribution")
		let distdecider = KCDistributionDecider()
		view.accept(visitor: distdecider)
	}
}

