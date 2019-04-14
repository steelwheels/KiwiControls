/**
 * @file	ViewController.swift
 * @brief	Define ViewController class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import KiwiControls

class ViewController: KCMultiViewController
{
	override func viewDidLoad() {
		NSLog("ViewController: viewDidLoad")
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		let console	= CNLogConsole(debugLevel: .Flow, toConsole: KCLogConsole.shared)

		/* Load log view */
		let logname = "log0"
		let logcont = UTLogViewController(parentViewController: self, console: console, doVerbose: true)
		self.add(name: logname, viewController: logcont)

		/* Load 1st view */
		let labname = "label0"
		let labcont = SingleView0Controller(parentViewController: self, console: console, doVerbose: true)
		self.add(name: labname, viewController: labcont)

		if self.pushViewController(byName: logname) {
			log(type: .Flow, string: "Select ... OK", file: #file, line: #line, function: #function)
		} else {
			log(type: .Flow, string: "Select ... NG", file: #file, line: #line, function: #function)
		}
		log(type: .Flow, string: "View id \(logname) \(labname)\n", file: #file, line: #line, function: #function)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

