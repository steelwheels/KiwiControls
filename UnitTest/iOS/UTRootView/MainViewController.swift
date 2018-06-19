/**
 * @file	KCMainViewController.swift
 * @brief	Define KCMainViewController class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiControls

class MainViewController: KCViewController
{
	@IBOutlet weak var mRootView: KCRootView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		let console = KCLogConsole()
		console.print(string: "mainViewController: viewDidLoad\n")

		// Do any additional setup after loading the view.
		let frame  = mRootView.frame
		let button = KCButton()
		let text   = KCTextEdit()
		let box    = KCStackView(frame: frame)
		box.addArrangedSubView(subView: text)
		box.addArrangedSubView(subView: button)

		mRootView.setupContext(childView: box)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

