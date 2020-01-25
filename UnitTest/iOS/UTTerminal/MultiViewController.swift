/**
 * @file	MultiViewController.swift
 * @brief	Define KCRootView class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiControls
import CoconutData
import UIKit

class MultiViewController: KCMultiViewController
{
	override func loadView() {
		super.loadView()

		/* Allocate cosole */
		let console = KCLogManager.shared.console
		super.set(console: console)

		/* Allocate terminal view */
		let terminalcontroller = SingleViewController(parentViewController: self, console: console)
		self.add(name: "terminal", viewController: terminalcontroller)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidAppear(_ doanimate: Bool) {
		super.viewDidAppear(doanimate)

		if self.pushViewController(byName: "terminal") {
			if let cons = self.console {
				cons.print(string: "termial view ready")
			}
		} else {
			if let cons = self.console {
				cons.print(string: "termial view is NOT ready")
			}
		}
	}
}

