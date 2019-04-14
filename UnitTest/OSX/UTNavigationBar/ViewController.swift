//
//  ViewController.swift
//  UTNavigationBar
//
//  Created by Tomoo Hamada on 2019/01/23.
//  Copyright © 2019 Steel Wheels Project. All rights reserved.
//

import CoconutData
import KiwiControls
import Cocoa

class ViewController: NSViewController, CNLogging
{
	public var console: CNLogConsole? = nil

	@IBOutlet weak var mNavigationBar: KCNavigationBar!

	override func viewDidLoad() {
		super.viewDidLoad()

		/* Allocate console */
		let wincons = KCLogConsole.shared
		let newcons = CNLogConsole(debugLevel: .Flow, toConsole: wincons)
		console = newcons

		// Do any additional setup after loading the view.
		mNavigationBar.title = "Hello, World !!"

		mNavigationBar.isLeftButtonEnabled	= true
		mNavigationBar.leftButtonTitle		= "Left"
		mNavigationBar.leftButtonPressedCallback = {
			() -> Void in
			wincons.print(string: "Left button pressed\n")
		}

		mNavigationBar.isRightButtonEnabled	= true
		mNavigationBar.rightButtonTitle		= "Right"
		mNavigationBar.rightButtonPressedCallback = {
			() -> Void in
			wincons.print(string: "Right button pressed\n")
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

