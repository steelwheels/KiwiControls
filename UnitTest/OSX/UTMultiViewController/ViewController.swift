/**
 * @file ViewController.swift
 * @brief Define ViewController class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiControls
import CoconutData
import Cocoa

class ViewController: KCMultiViewController
{
	override func viewDidLoad() {
		super.viewDidLoad()

		/* Allocate console */
		let logcons  = KCLogConsole.shared
		let newcons  = CNLogConsole(debugLevel: .Flow, toConsole: logcons)
		console = newcons

		let cont0      = SingleView0Controller(parentViewController: self, console: newcons, doVerbose: true)
		self.add(name: "cont0", viewController: cont0)

		let cont1      = SingleView1Controller(parentViewController: self, console: newcons, doVerbose: true)
		self.add(name: "cont1", viewController: cont1)

		let cont2      = SingleView2Controller(parentViewController: self, console: newcons, doVerbose: true)
		self.add(name: "cont2", viewController: cont2)

		let _ = self.pushViewController(byName: "cont0")
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

