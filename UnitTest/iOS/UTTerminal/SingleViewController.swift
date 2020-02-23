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

	open override func loadView() {
		super.loadView()

		let terminalview = KCTerminalView()
		mTerminalView = terminalview

		if let root = super.rootView {
			root.setup(childView: terminalview)
		} else {
			NSLog("Failed to set terminal")
		}
	}

	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		if let termview = mTerminalView {
			termview.outputFileHandle.write(string: "Hello, world")
		}
	}
}

