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
	open override func loadView() {
		super.loadView()

		let terminalview       = KCTerminalView()
		terminalview.outputFileHandle.write(string: "Hello, world")
		if let root = super.rootView {
			root.setup(childView: terminalview)
		} else {
			NSLog("Failed to set terminal")
		}
	}
}

