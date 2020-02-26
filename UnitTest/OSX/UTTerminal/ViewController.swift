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

class ViewController: KCPlaneViewController
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

		/* Update size */
		NSLog("Request to update the size of terminal")
		termview.currentColumnNumbers	= 80
		termview.currentRowNumbers	= 25
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

