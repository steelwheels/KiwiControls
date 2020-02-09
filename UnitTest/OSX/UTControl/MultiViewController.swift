/**
 * @file	ViewController.swift
 * @brief	View controller for UTControl
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Cocoa
import CoconutData
import KiwiControls

class MultiViewController: KCMultiViewController
{
	override func loadView() {
		super.loadView()

		/* Allocate cosole */
		let console = KCLogManager.shared.console
		super.set(console: console)

		/* Allocate terminal view */
		let terminalcontroller = SingleViewController(parentViewController: self, console: console)
		self.add(name: "control", viewController: terminalcontroller)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	public override func viewDidAppear() {
		super.viewDidAppear()

		if self.pushViewController(byName: "control") {
			if let cons = self.console {
				cons.print(string: "termial view ready")
			}
		} else {
			if let cons = self.console {
				cons.print(string: "termial view is NOT ready")
			}
		}
	}
}

/*
	
	@IBOutlet weak var mPreferenceView: KCTerminalPreferenceView!
	@IBOutlet weak var mTerminalView: KCTerminalView!

	override func viewDidLoad() {
		super.viewDidLoad()

		NSLog("viewDidLoad")

		mTerminalView.outputFileHandle.write(string: "Hello, world!!")

		mPreferenceView.textColorCallbackFunc = {
			(_ color: KCColor) -> Void in
			self.mTerminalView.textColor = color
		}
		mPreferenceView.backgroundColorCallbackFunc = {
			(_ color: KCColor) -> Void in
			self.mTerminalView.backgroundColor = color
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}
*/

