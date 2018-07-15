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

	private var mConsole: CNConsole? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	public override func viewWillAppear() {
		super.viewWillAppear()
		let cons = KCLogConsole()
		allocateComponents(rootView: mRootView, console: cons)
		compile(rootView: mRootView, console: cons)

		mConsole = cons
	}

	public override func viewDidAppear() {
		mConsole!.print(string: "// viewDidAppear\n")
		let dumper = KCViewDumper(console: mConsole!)
		dumper.dump(view: mRootView)
	}

	private func allocateComponents(rootView root: KCRootView, console cons: CNConsole) {
		if let window = self.view.window {
			let box    = KCStackView(frame: window.frame)
			box.distribution = .fill

			let label = KCTextField()
			label.text = "Label"

			let text  = KCTextEdit()
			text.text = ""
			text.isEditable = false

			let button = KCButton()
			button.title = "Press me"
			box.addArrangedSubViews(subViews: [label, text, button])
			root.setupContext(childView: box)
		} else {
			cons.error(string: "Failed to get window (1)")
		}
	}

	private func compile(rootView root: KCRootView, console cons: CNConsole){
		if let window = self.view.window {
			let layouter = KCLayouter(console: cons)
			layouter.layout(rootView: root, rootSize: window.frame.size)
		} else {
			cons.error(string: "Failed to get window (2)")
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

