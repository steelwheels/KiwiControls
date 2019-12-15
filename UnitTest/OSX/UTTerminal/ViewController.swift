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
		let instrm  : CNFileStream = .fileHandle(mTerminalView.inputFileHandle)
		let outstrm : CNFileStream = .fileHandle(mTerminalView.outputFileHandle)
		let errstrm : CNFileStream = .fileHandle(mTerminalView.errorFileHandle)
		let conf	= CNConfig(logLevel: .flow)
		NSLog("Allocate shell")
		let shell     = CNShellThread(input: instrm, output: outstrm, error: errstrm, config: conf, terminationHander: nil)
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
		let colnum   = mTerminalView.columnNumbers
		let rownum   = mTerminalView.lineNumbers
		NSLog("colnun=\(colnum), rownum=\(rownum)")

		/* Send screen size */
		NSLog("Send request")
		let reqstr = CNEscapeCode.requestScreenSize.encode()
		mTerminalView.outputFileHandle.write(string: reqstr)

		/*
		NSLog("Accepted code")
		let ackdata = mTerminalView.inputFileHandle.availableData
		if let ackstr = String(data: ackdata, encoding: .utf8) {
			switch CNEscapeCode.decode(string: ackstr) {
			case .ok(let codes):
				for code in codes {
					NSLog("code: \(code.description())")
				}
			case .error(let err):
				NSLog("Internal error: \(err.description())")
			}
		}
		*/
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

