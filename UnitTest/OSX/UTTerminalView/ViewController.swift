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

	@IBOutlet weak var mTerminalView: KCTerminalView!

	override func viewDidLoad() {
		super.viewDidLoad()

		mTerminalView.appendText(string: NSAttributedString(string: "Hello, world"))
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

