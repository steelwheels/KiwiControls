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

		/* Load 1st view */
		let size       = contentSize()
		let console    = CNFileConsole()
		let controller = UTSingleViewController(size: size, console: console)
		let _          = self.add(name: "label0", viewController: controller)
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

