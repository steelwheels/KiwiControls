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

	public func preLayout(rootView view: KCRootView, maxSize maxsz: CGSize){
		CNLog(logLevel: .detail, message: "[Layout] Preprocessor")
		let propagator = KCLayoutPropagator(limitSize: maxsz)
		view.accept(visitor: propagator)

		CNLog(logLevel: .detail, message: "[Layout] Adjust expandability")
		let adjuster = KCExpansionAdjuster()
		view.accept(visitor: adjuster)

		CNLog(logLevel: .detail, message: "[Layout] Decide distribution")
		let distdecider = KCDistributionDecider()
		view.accept(visitor: distdecider)

		CNLog(logLevel: .detail, message: "[Layout] Check layout")
		let checker = KCLayoutChecker()
		view.accept(visitor: checker)
	}

	public func postLayout(rootView view: KCRootView, maxSize maxsz: CGSize){
		#if os(iOS)
			CNLog(logLevel: .detail, message: "[Layout] Update window size")
			view.setFrameSize(maxsz)
		#endif
	}
}

