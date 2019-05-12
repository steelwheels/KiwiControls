/**
 * @file	KCLayoutFinalizer.swift
 * @brief	Define KCLayoutFinalizer class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCLayoutFinalizer: CNLogging
{
	private var mConsole:		CNConsole

	public required init(console cons: CNConsole){
		mConsole	= cons
	}

	public var console: CNConsole? {
		get { return mConsole }
	}

	public func finalizeLayout(rootView view: KCRootView){
		log(type: .Flow, string: "Frame size finalizer", file: #file, line: #line, function: #function)
		let sizefinalizer = KCFrameSizeFinalizer(console: mConsole)
		view.accept(visitor: sizefinalizer)
	}
}

