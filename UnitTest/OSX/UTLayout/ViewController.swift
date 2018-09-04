/**
 * @file	ViewController.swift
 * @brief	View controller for unit test
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiControls
import CoconutData
import Cocoa

class ViewController: KCViewController
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

	private func allocateComponents(rootView root: KCRootView, console cons: CNConsole)
	{
		let frame  = KCViewController.rootFrame(viewController: self)
		let box    = KCStackView(frame: frame)
		box.distribution = .fill

		let label = KCTextField()
		label.text = "Label"

		let text  = KCTextEdit()
		text.text = ""
		text.isEditable = false

		let button = KCButton()
		button.title = "Press me"
		box.addArrangedSubViews(subViews: [label, text, button])

		let inset = KCViewController.safeAreaInsets(viewController: self)
		root.setup(viewController: self, childView: box, in: inset)
	}

	private func compile(rootView root: KCRootView, console cons: CNConsole){
		if let _ = self.view.window {
			let rootframe = KCViewController.rootFrame(viewController: self)
			let layouter  = KCLayouter(rootFrame: rootframe, console: cons)
			layouter.layout(rootView: root)
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

