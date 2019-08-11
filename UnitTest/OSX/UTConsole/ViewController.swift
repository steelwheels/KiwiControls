//
//  ViewController.swift
//  UTConsole
//
//  Created by Tomoo Hamada on 2019/08/10.
//  Copyright © 2019 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import CoconutData
import Cocoa

class ViewController: NSViewController {

	@IBOutlet weak var mConsoleView: KCConsoleView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		mConsoleView.appendText(normal: "Hello, world !!\n")
	}

	override func viewDidAppear() {
		let width   = mConsoleView.bounds.width
		let height  = mConsoleView.bounds.height
		let linenum = mConsoleView.lineNumbers
		let colnum  = mConsoleView.columnNumbers
		mConsoleView.appendText(normal: "\(width) x \(height) -> \(colnum) x \(linenum)\n")

		for _ in 0..<colnum {
			mConsoleView.appendText(normal: "*")
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

