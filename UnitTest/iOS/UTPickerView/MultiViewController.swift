/**
 * @file	MainViewController.swift
 * @brief	Define MainViewController class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import KiwiControls
import UIKit

class MultiViewController: KCMultiViewController
{
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		let console	= CNFileConsole()

		/* Add first view */
		let firstcont = FirstViewController(parentViewController:self, console: console, doVerbose: true)
		self.add(name: "firstView", viewController: firstcont)

		/* Push first view */
		guard self.pushViewController(byName: "firstView") else {
			NSLog("Failed to select")
			return
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
