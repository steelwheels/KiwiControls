//
//  ViewController.swift
//  UTStackView
//
//  Created by Tomoo Hamada on 2017/04/23.
//  Copyright © 2017年 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import Cocoa

class ViewController: NSViewController
{
	@IBOutlet weak var mStackView: KCStackView!

	override func viewDidLoad()
	{
		super.viewDidLoad()

		let selection = 0
		switch selection {
		case 0:
			addSubviews_0()
		case 1:
			addSubviews_1()
		}

		Swift.print("[ViewDidLoad]")
		mStackView.printDebugInfo(indent: 0)
	}

	private func addSubviews_0()
	{
		//mStackView.axis = .Holizontal
		mStackView.axis = .Vertical
		mStackView.alignment = .Trailing

		let text0 = KCTextField()
		text0.text = "Hello, Field !!!!!"

		let button0 = KCButton()
		button0.title = "Button-0"

		mStackView.setViews(views: [text0, button0])
	}

	private func addSubviews_1()
	{
		mStackView.axis = .Vertical

		let origin     = NSPoint.zero
		let size       = mStackView.frame.size
		let halfsize   = NSSize(width: size.width, height: size.height/2.0)
		let quatersize = NSSize(width: size.width/4.0, height: size.height/4.0)

		let text0 = KCTextField(frame: NSRect(origin: origin, size: quatersize))
		text0.text = "Hello, Field !!!!!"

		let button0 = KCButton(frame: NSRect(origin: origin, size: quatersize))
		button0.title = "Button-0"

		let box0 = KCStackView(frame: NSRect(origin: origin, size: halfsize))
		box0.axis = .Holizontal
		//box0.alignment = .Trailing
		box0.setViews(views: [text0, button0])

		let button1 = KCButton(frame: NSRect(origin: origin, size: quatersize))
		button1.title = "Button-1"
		mStackView.setViews(views: [box0, button1])
	}

	override func viewDidLayout() {
		super.viewDidLayout()

		Swift.print("[ViewDidLayout]")
		mStackView.printDebugInfo(indent: 0)
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

