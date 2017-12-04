/**
 * @file	ViewController.swift
 * @brief	ViewController class for UTTerminalView
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiControls
import Cocoa

class ViewController: NSViewController
{
	@IBOutlet weak var mTerminalView: KCCLITerminalView!

	override func viewDidLoad() {
		super.viewDidLoad()

		/*
		mTerminalView.foregroundColor = NSColor.green
		mTerminalView.backgroundColor = NSColor.black

		mTerminalView.append(string: "Hello, world\n")

		mTerminalView.append(string: "Good, morning\n")
		let size = mTerminalView.size
		NSLog("fontsize: width=\(size.width), height=\(size.height)")
		for i in 0..<size.width {
			let c = i % 10
			mTerminalView.append(string: "\(c)")
		}

		let linecount = mTerminalView.lineCount
		NSLog("lineCount=\(linecount)")
*/
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

