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

class ViewController: KCPlaneViewController, NSWindowDelegate
{
	private var	mTerminalView:	KCTerminalView? = nil
	private var	mShell: CNShellThread? = nil

	override func loadView() {
		super.loadView()

		/* Allocate preference view */
		if let rootview = super.rootView {
			let termview = KCTerminalView()
			rootview.setup(childView: termview)
			mTerminalView = termview

			/* Allocate shell */
			NSLog("Launch terminal")
			let queue   : DispatchQueue = DispatchQueue(label: "Terminal", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
			let instrm  : CNFileStream = .fileHandle(termview.inputFileHandle)
			let outstrm : CNFileStream = .fileHandle(termview.outputFileHandle)
			let errstrm : CNFileStream = .fileHandle(termview.errorFileHandle)
			NSLog("Allocate shell")
			let shell     = CNShellThread(queue: queue, input: instrm, output: outstrm, error: errstrm)
			mShell        = shell
		}
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		/* Set delegate */
		if let win = view.window {
			win.delegate = self
		}

		guard let termview = mTerminalView else {
			NSLog("No terminal view")
			return
		}

		/* Set font size */
		NSLog("Font point size: \(termview.fontPointSize)")
		//mTerminalView.fontPointSize = 16.0

		/* Start shell */
		if let shell = mShell {
			NSLog("start shell")
			shell.start(arguments: [])
		}

		/*
		let colnum   = termview.columnNumbers
		let rownum   = termview.lineNumbers
		NSLog("colnun=\(colnum), rownum=\(rownum)")
		*/

		/* Send screen size */
		/*
		NSLog("Send request")
		let reqstr = CNEscapeCode.requestScreenSize.encode()
		termview.outputFileHandle.write(string: reqstr)
		*/

		/* Update preference */
/*
		let pref = CNPreference.shared.terminalPreference
		pref.foregroundTextColor = KCColor.green
		pref.backgroundTextColor = KCColor.black
*/
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
		if let win = view.window, let termview = mTerminalView {
			let newsize = win.frame.size
			NSLog("Resize: \(newsize.description)")
			termview.resize(newsize)
		}
	}
}

