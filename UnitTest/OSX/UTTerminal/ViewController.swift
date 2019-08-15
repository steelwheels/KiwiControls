/**
 * @file ViewController.swift
 * @brief Define ViewController class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiControls
import CoconutData
import CoconutShell
import Cocoa

class UTShell: CNShell
{

}

class ViewController: NSViewController, NSWindowDelegate {

	@IBOutlet weak var	mTerminalView: KCTerminalView!
	private var		mShell: UTShell? = nil

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		NSLog("Launch terminal")
		let interface = CNShellInterface()
		let shell     = UTShell(interface: interface)
		mShell        = shell
		mTerminalView.shellInterface = interface
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		/* Set delegate */
		if let win = view.window {
			win.delegate = self
		}
		/* Start shell */
		if let shell = mShell {
			NSLog("start shell")
			shell.prompt = "$"
			shell.start()
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

