//
//  ViewController.swift
//  UTTerminal
//
//  Created by Tomoo Hamada on 2019/08/11.
//  Copyright © 2019 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import CoconutData
import Cocoa

class ViewController: NSViewController {

	@IBOutlet weak var mTerminalView: KCTerminalView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		NSLog("Launch terminal")
		mTerminalView.appendText(normal: "Hello, world !!")
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

