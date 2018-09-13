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
	private var mViewController:	KCSingleViewController
	private var mConsole:		CNConsole

	public init(viewController vcont: KCSingleViewController, console cons: CNConsole){
		mViewController = vcont
		mConsole	= cons
	}

	public func layout(rootView view: KCRootView){
		let sizefitter = KCSizeFitLayouter()
		view.accept(visitor: sizefitter)

		let frmallocator = KCFrameAllocLayouter(viewController: mViewController, console: mConsole)
		view.accept(visitor: frmallocator)
	}
}

