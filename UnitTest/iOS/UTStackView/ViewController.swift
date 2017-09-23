/**
 * @file	ViewController.swift
 * @brief	Define ViewController class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiControls
import CoreGraphics
import UIKit

class ViewController: UIViewController
{
	@IBOutlet weak var mStackView: KCStackView!

	override func viewDidLoad()
	{
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		let field0 = KCTextField()
		field0.text = "TextField"

		let button0 = KCButton()
		button0.title = "Hello"

		let button1 = KCButton()
		button1.title = "Goodbye"

		let box0 = KCStackView()
		box0.addArrangedSubViews(subViews: [field0, button0, button1])
		box0.axis = .Holizontal

		let text1 = KCConsoleView()
		let astr = NSAttributedString(string: "welcome to ViewController")
		text1.appendText(string: astr)

		mStackView.addArrangedSubViews(subViews: [text1, box0])
		mStackView.axis = .Vertical
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewDidAppear(_ animated: Bool) {
		mStackView.printDebugInfo(indent: 0)
	}
}

