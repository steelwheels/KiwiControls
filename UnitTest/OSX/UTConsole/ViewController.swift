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
		dumpSize(title: "Before")
		let colnum  = mConsoleView.columnNumbers
		for _ in 0..<colnum {
			mConsoleView.appendText(normal: "*")
		}
		for i in 0..<40 {
			mConsoleView.appendText(normal: "*\(i)\n")
		}
		dumpSize(title: "After")

		let logcons = KCLogManager.shared.console
		logcons.print(string: "Hello, log console")
	}

	private func dumpSize(title titlestr: String){
		let width   = mConsoleView.bounds.width
		let height  = mConsoleView.bounds.height
		let linenum = mConsoleView.lineNumbers
		let colnum  = mConsoleView.columnNumbers
		NSLog("[\(titlestr)] \(width) x \(height) -> \(colnum) x \(linenum)\n")
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

