/**
 * @file	KCLogViewController.swift
 * @brief	Define KCLogViewController class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiControls
import Foundation

class LogViewController: KCViewController
{
	@IBOutlet weak var mConsoleView: KCConsoleView!

	override func viewDidLoad() {
		super.viewDidLoad()

		//NSLog("LogViewController: viewDidLoad")
		let controller = KCLogViewController.shared
		controller.setLogViewConsole(console: mConsoleView.console)

		let console = KCLogConsole()
		console.print(string: "logViewController: viewDidLoad\n")
	}
}

