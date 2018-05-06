//
//  ViewController.swift
//  UTLogWindow
//
//  Created by Tomoo Hamada on 2018/05/06.
//  Copyright © 2018年 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import Cocoa

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		
		// Do any additional setup after loading the view.
		let cons = KCLogConsole()
		cons.show()
		cons.print(string: "Hello, world !!\nGood morning !!\n\n")
		cons.hide()
		cons.print(string: "Good night ...\n")
		cons.show()
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

