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
		let frame  = CGRect(origin: CGPoint.zero, size: CGSize(width:200,height:32))
		let button0 = KCButton(frame: frame)
		button0.title = "Hello"
		mStackView.addContentView(view: button0)

		let button1 = KCButton(frame: frame)
		button1.title = "Goodbye"
		mStackView.addContentView(view: button1)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

