/**
 * @file	ViewController.swift
 * @brief	ViewController class for UTStackView
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiControls
import Cocoa

class UTViewController: NSViewController
{
	@IBOutlet weak var mStackView: KCStackView!

	override func viewDidLoad()
	{
		super.viewDidLoad()

		let selection = 1
		switch selection {
		case 0:
			addSubviews_0()
		case 1:
			addSubviews_1()
		default:
			break
		}
		
		Swift.print("[ViewDidLoad]")
		mStackView.printDebugInfo(indent: 0)
	}

	private func addSubviews_0()
	{
		mStackView.orientation = .Vertical
		//mStackView.axis = .Vertical
		mStackView.alignment = .Trailing

		let text0 = KCTextField()
		text0.text = "Hello, Field !!!!!"

		let button0 = KCButton()
		button0.title = "Button-0"

		mStackView.addArrangedSubViews(subViews: [text0, button0])
	}

	private func addSubviews_1()
	{
		mStackView.orientation = .Vertical

		let origin     = NSPoint.zero
		let size       = mStackView.frame.size
		let halfsize   = NSSize(width: size.width, height: size.height/2.0)

		let text0 = KCTextField()
		text0.text = "Hello, Field !!!!!"

		let button0 = KCButton()
		button0.title = "Button-0"

		let button1 = KCButton()
		button1.title = "Button-1"

		let box0 = KCStackView(frame: NSRect(origin: origin, size: halfsize))
		box0.orientation = .Horizontal
		//box0.orientation = .Vertical
		//box0.alignment = .Trailing
		box0.addArrangedSubViews(subViews:  [text0, button0, button1])

		let button2 = KCButton()
		button2.title = "Button-2"

		let text1 = KCConsoleView()
		let console1 = text1.console
		console1.print(string: "Hello, world !!")

		mStackView.addArrangedSubViews(subViews: [box0, text1, button2])
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

