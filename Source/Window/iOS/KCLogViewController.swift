/**
 * @file	KCLogViewController.swift
 * @brief	Define KCLogViewController class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCLogViewController: KCSingleViewController
{
	private var mConsoleView: KCConsoleView?    = nil
	private var mConsole:	  CNBufferedConsole = CNBufferedConsole()

	public override func loadView() {
		/* Setup root view */
		super.loadView()
		
		/* Add text field */
		let console = KCConsoleView(frame: safeArea())
		if let root = super.rootView {
			root.setup(viewController: self, childView: console)
			mConsoleView = console
			mConsole.outputConsole = console.console
		} else {
			NSLog("\(#function) [Error] Can not allocate console view")
		}
	}

	public var console: CNConsole {
		get { return mConsole }
	}
}


