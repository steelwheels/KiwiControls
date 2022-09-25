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
		#if os(OSX)
		CNLog(logLevel: .detail, message: "[Layout] Adjust expandability")
		let adjuster = KCExpansionAdjuster()
		view.accept(visitor: adjuster)
		#endif // os(OSX)

		CNLog(logLevel: .detail, message: "[Layout] Decide distribution")
		let distdecider = KCDistributionDecider()
		view.accept(visitor: distdecider)
	}
}

