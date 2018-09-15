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
		let console    = CNFileConsole()

		let cont0      = SingleView0Controller(parentViewController: self, console: console, doVerbose: true)
		let idx0       = self.add(name: "cont0", viewController: cont0)

		let cont1      = SingleView1Controller(parentViewController: self, console: console, doVerbose: true)
		let idx1       = self.add(name: "cont1", viewController: cont1)

		let cont2      = SingleView2Controller(parentViewController: self, console: console, doVerbose: true)
		let idx2       = self.add(name: "cont2", viewController: cont2)

		let _ = self.select(byIndex: idx2)

		Swift.print("Select \(idx0) from [\(idx0). \(idx1), \(idx2)]")
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

