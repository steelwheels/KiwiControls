/**
 * @file	SingleViewController.swift
 * @brief	Define SingleViewController class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiControls
import CoconutData
import UIKit

class SingleViewController: KCSingleViewController
{
	private var mTerminalView: KCTerminalView? = nil

	open override func loadViewContext(rootView root: KCRootView) -> KCSize {
		let terminalview = KCTerminalView()
		mTerminalView = terminalview
		root.setup(childView: terminalview)
		return terminalview.fittingSize
	}

	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		if let termview = mTerminalView {
			termview.outputFileHandle.write(string: "Hello, world")
		}
	}
}

