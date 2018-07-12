/**
 * @file	ViewController.swift
 * @brief	View controller for unit test
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiControls
import CoconutData
import Cocoa

class ViewController: NSViewController
{
	@IBOutlet weak var mRootView: KCRootView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	public override func viewWillAppear() {
		super.viewWillAppear()
		allocateComponents(rootView: mRootView)
		compile(rootView: mRootView)
	}

	private func allocateComponents(rootView root: KCRootView) {
		if let window = self.view.window {
			let box    = KCStackView(frame: window.frame)
			let label  = KCTextEdit()
			label.text = ""
			label.isEditable = false
			let button = KCButton()
			button.title = "Press me"
			box.addArrangedSubViews(subViews: [label, button])
			root.setupContext(childView: box)
		} else {
			NSLog("Failed to get window (1)")
		}
	}

	private func compile(rootView root: KCRootView){
		if let window = self.view.window {
			let console  = CNFileConsole()
			let layouter = KCLayouter(console: console)
			layouter.layout(rootView: root, rootSize: window.frame.size)
		} else {
			NSLog("Failed to get window (2)")
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

