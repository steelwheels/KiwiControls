//
//  ViewController.swift
//  UTNavigationBar
//
//  Created by Tomoo Hamada on 2019/01/23.
//  Copyright © 2019 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import Cocoa

class ViewController: NSViewController
{
	@IBOutlet weak var mNavigationBar: KCNavigationBar!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		mNavigationBar.title = "Hello, World !!"

		mNavigationBar.isLeftButtonEnabled	= true
		mNavigationBar.leftButtonTitle		= "Left"
		mNavigationBar.leftButtonPressedCallback = {
			() -> Void in
			NSLog("Left button pressed")
		}

		mNavigationBar.isRightButtonEnabled	= true
		mNavigationBar.rightButtonTitle		= "Right"
		mNavigationBar.rightButtonPressedCallback = {
			() -> Void in
			NSLog("Right button pressed")
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

