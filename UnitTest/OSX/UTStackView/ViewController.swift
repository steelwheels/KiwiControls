/**
 * @file	ViewController.swift
 * @brief	ViewController class for UTStackView
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import KiwiControls
import Cocoa

class ViewController:  KCPlaneViewController
{
	private var mStackView:		KCStackView? = nil

	open override func loadViewContext(rootView root: KCRootView) -> KCSize {
		let buttonview = KCButton()
		buttonview.title = "Hello"
		buttonview.buttonPressedCallback = {
			() -> Void in
			self.popupMenu()
		}
		let stackview = KCStackView()
		root.setup(childView: stackview)
		stackview.addArrangedSubView(subView: buttonview)
		mStackView = stackview
		return stackview.fittingSize
	}

	override func viewWillLayout() {
		NSLog("viewWillLayout")
		super.viewWillLayout()
	}

	override func viewDidLayout() {
		NSLog("viewDidLayout")
		super.viewDidLayout()
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	private func popupMenu() {
		if let parent = mStackView {
			let item0 = KCContextualMenu.MenuItem(index: 0, label: "label0")
			let item1 = KCContextualMenu.MenuItem(index: 0, label: "label1")
			let menu  = KCContextualMenu()
			let pos   = KCPoint(x: 0.0, y: 0.0)
			menu.add(menuItems: [item0, item1])
			if let idx = menu.show(at: pos, in: parent) {
				NSLog("popupmenu - selected: \(idx)")
			} else {
				NSLog("popupmenu - not selected")
			}
		}
	}
}

