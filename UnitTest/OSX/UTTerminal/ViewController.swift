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

class ViewController: NSViewController, NSWindowDelegate {

	@IBOutlet weak var	mTerminalView: KCTerminalView!
	private var		mShell: CNShellThread? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		/* Allocate shell */
		NSLog("Launch terminal")
		let inhdl	= mTerminalView.inputFileHandle
		let outhdl	= mTerminalView.ouptutFileHandle
		let errhdl	= mTerminalView.errorFileHandle
		let env		= CNShellEnvironment()
		let conf	= CNConfig(doVerbose: true)
		NSLog("Allocate shell")
		let shell     = CNShellThread(input: inhdl, output: outhdl, error: errhdl, environment: env, config: conf)
		mShell        = shell
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

