/**
 * @file	SingleViewController.swift
 * @brief	Define SingleViewController class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiControls
import CoconutData
import Cocoa

class SingleViewController: KCSingleViewController
{
	open override func loadView() {
		super.loadView()

		let prefview = KCTerminalPreferenceView()
		/*
		if let cons = super.console {
			let dumper = KCViewDumper(console: cons)
			dumper.dump(view: prefview)
		}*/
		if let root = super.rootView {
			root.setup(childView: prefview)
		} else {
			NSLog("Failed to set controls")
		}
	}
}

