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
	@IBOutlet weak var mBackgroundView: UIView!

	override func viewDidLoad() {
		NSLog("ViewController: viewDidLoad")
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let console	= CNFileConsole()

		/* Load log view */
		let logcont  = KCLogViewController(parentViewController: self, console: console)
		let logid    = self.add(name: "log0", viewController: logcont)

		/* Load 1st view */
		let labcont  = UTSingleViewController(parentViewController: self, console: logcont.console)
		let labid    = self.add(name: "label0", viewController: labcont)

		self.select(byIndex: logid)
		//self.select(byIndex: labid)

		logcont.console.print(string: "View id \(logid) \(labid)\n")
		logcont.console.print(string: "2nd line\n")
		logcont.console.print(string: "3rd line\n")
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

