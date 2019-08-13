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

class UTTerminal: KCTerminalDelegate {
	func put(line str: String) {
		NSLog("UTTerminal.put(\(str))")
	}
}

class ViewController: NSViewController, NSWindowDelegate {

	@IBOutlet weak var mTerminalView: KCTerminalView!
	private var mTerminalObject: UTTerminal? = nil

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		NSLog("Launch terminal")
		mTerminalObject = UTTerminal()
		mTerminalView.terminalDelegate = mTerminalObject
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		/* Set delegate */
		if let win = view.window {
			win.delegate = self
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	public func windowDidResize(_ notification: Notification) {
		if let win = view.window {
			let newsize = win.frame.size
			NSLog("Resize: \(newsize.description)")
			mTerminalView.resize(newsize)
		}
	}
}

