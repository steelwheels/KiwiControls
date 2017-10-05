//
//  ViewController.swift
//  UTWindowController
//
//  Created by Tomoo Hamada on 2017/09/24.
//  Copyright © 2017年 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import Cocoa

private class UTWindowController: KCWindowController
{
	open override func windowDidLoad() {
		super.windowDidLoad()
		Swift.print("windowDidLoad")
	}
}

class ViewController: KCViewController {

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

	private var mWindowController: KCWindowController? = nil
	private func openWindow() {
		Swift.print("open window")
		if mWindowController == nil {
			let newcontroller = UTWindowController()
			newcontroller.showWindow(nil)
			mWindowController = newcontroller

			if let window = newcontroller.window as? KCWindow {
				let button0 = KCButton()
				button0.title = "Close"
				button0.buttonPressedCallback = {
					() -> Void in
					Swift.print("Close button pressed")
				}
				let stackview = KCStackView()
				stackview.addArrangedSubView(subView: button0)
				window.setRootView(view: stackview)
			} else {
				fatalError("Invalid window object")
			}
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

