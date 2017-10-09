//
//  ViewController.swift
//  UTWindowController
//
//  Created by Tomoo Hamada on 2017/09/24.
//  Copyright © 2017年 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import Cocoa

private class UTWindowController: NSWindowController
{
	open override func windowDidLoad() {
		super.windowDidLoad()
		Swift.print("windowDidLoad")
	}
}

class ViewController: NSViewController {

@	IBOutlet weak var mStackView: KCStackView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		let button0 = KCButton()
		button0.title = "Button-0"
		button0.buttonPressedCallback = {
			() -> Void in
			self.openWindow()
		}
		mStackView.addArrangedSubView(subView: button0)
	}

	private var mWindowController: NSWindowController? = nil

	private func openWindow() {
		Swift.print("open window")
		if mWindowController == nil {
			let vcont = KCViewController.loadViewController(delegate: nil)

			let window = KCWindow(contentViewController: vcont)
			let wcont = UTWindowController(window: window)
			wcont.showWindow(nil)
			mWindowController = wcont

			let button0 = KCButton()
			button0.title = "Close"
			button0.buttonPressedCallback = {
				() -> Void in
				Swift.print("Close button pressed")
			}
			window.setRootView(view: button0)
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

