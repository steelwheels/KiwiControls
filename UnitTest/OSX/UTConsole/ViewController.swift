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
		NSLog("viewDidLoad")
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		//mConsoleView.consoleConnection.print(string: "Hello, world !!\n")
	}

	override func viewDidAppear() {
		NSLog("viewDidAppear")
		dumpSize(title: "Before")
		let colnum  = mConsoleView.columnNumbers
		for _ in 0..<colnum {
			NSLog("viewDidAppear (1)")
			mConsoleView.consoleConnection.print(string: "*")
		}
		for i in 0..<40 {
			NSLog("viewDidAppear (2)")
			mConsoleView.consoleConnection.print(string: "*\(i)\n")
		}
		NSLog("viewDidAppear (3)")
		dumpSize(title: "After")

		NSLog("viewDidAppear (4)")
		//let logcons = KCLogManager.shared.console
		//logcons.print(string: "Hello, log console")
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

