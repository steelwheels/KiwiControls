/**
 * @file	KCMainViewController.swift
 * @brief	Define KCMainViewController class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiControls

class MainViewController: KCViewController
{
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		let console = KCLogConsole()
		console.print(string: "mainViewController: viewDidLoad\n")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

