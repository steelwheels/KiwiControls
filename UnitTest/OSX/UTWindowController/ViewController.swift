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
		Swift.print("*** open window")
		if mWindowController == nil {
			Swift.print("*** load view controller")
			let delegate = UTViewControllerDelegate()
			let vcont    = KCViewController.loadViewController(delegate: delegate)
			Swift.print("*** allocate window")
			let window   = KCWindow(contentViewController: vcont)
			let wcont    = UTWindowController(window: window)
			Swift.print("*** show window")
			wcont.showWindow(nil)
			mWindowController = wcont
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

private class UTViewControllerDelegate: KCViewControllerDelegate
{
	private var mDidAlreadyLoaded = false

	open override func viewDidLoad(rootView view: KCView){
		Swift.print("== UTViewControllerDelegate.viewDidLoad")
		/*
		let button0 = KCButton()
		button0.title = "Close"
		button0.buttonPressedCallback = {
			() -> Void in
			Swift.print("Close button pressed")
		}
		view.addSubview(button0)
		view.allocateSubviewLayout(subView: button0)*/
		//window.setRootView(view: button0)
	}

	open override func viewWillAppear(rootView view: KCView){
		Swift.print("== UTViewControllerDelegate.viewWillAppear")
		if !mDidAlreadyLoaded {
			let button0 = KCButton()
			button0.title = "Close"
			button0.buttonPressedCallback = {
				() -> Void in
				Swift.print("Close button pressed")
			}
			view.addSubview(button0)
			view.allocateSubviewLayout(subView: button0)

			mDidAlreadyLoaded = true
		}
	}

	open override func viewDidAppear(rootView view: KCView){
		Swift.print("== UTViewControllerDelegate.viewDidAppear")
	}
	/* Resize */
	open override func updateViewConstraints(rootView view: KCView){
		Swift.print("== UTViewControllerDelegate.updateViewConstraints")
	}
	/* Disappear */
	open override func viewWillDisappear(rootView view: KCView){
		Swift.print("== UTViewControllerDelegate.viewWillDisAppear")
	}
	open override func viewDidDisappear(rootView view: KCView){
		Swift.print("== UTViewControllerDelegate.viewDidDisAppear")
	}
}


