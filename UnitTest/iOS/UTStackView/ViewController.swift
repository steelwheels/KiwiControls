/**
 * @file	ViewController.swift
 * @brief	Define ViewController class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiControls
import CoconutData
import CoreGraphics
import UIKit

class ViewController: UIViewController
{
	@IBOutlet weak var mStackView: KCStackView!
	private var mConsoleView: KCConsoleView? = nil

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
		box0.alignment = .horizontal(align: .middle)

		let text1 = KCConsoleView()
		let astr = NSAttributedString(string: "welcome to ViewController")
		text1.appendText(string: astr)
		text1.backgroundColor = UIColor.cyan
		mConsoleView = text1

		mStackView.addArrangedSubViews(subViews: [box0, text1])
		mStackView.alignment = .vertical(align: .center)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewDidAppear(_ animated: Bool) {
		NSLog("\(#function): viewDidAppear")
		if let consview = mConsoleView {
			NSLog(" consoleView.frame = \(consview.frame)")
			let console = consview.console
			let dumper  = KCViewDumper(console: console)
			dumper.dump(view: mStackView)
		} else {
			NSLog("\(#function): No console view")
		}
	}
}

