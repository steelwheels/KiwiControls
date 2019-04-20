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
	private var mIsFirstAppearing = true

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if mIsFirstAppearing {
			viewDidFirstAppear()
		}
	}

	private func viewDidFirstAppear() {
		let logcons   = CNLogConsole(debugLevel: .Flow, toConsole: KCLogConsole.shared)
		set(logConsole: logcons)

		/* Add first view */
		let firstcont = SingleViewController(viewType: .firstView, parentViewController:self, console: logcons, doVerbose: true)
		self.add(name: "first_view", viewController: firstcont)

		let secondcont = SingleViewController(viewType: .secondView, parentViewController:self, console: logcons, doVerbose: true)
		self.add(name: "second_view", viewController: secondcont)

		/* Push first view */
		guard self.pushViewController(byName: "first_view") else {
			NSLog("Failed to select")
			return
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
