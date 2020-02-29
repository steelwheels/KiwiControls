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

	override func viewDidLoad()
	{
		super.loadView()

		/* Allocate preference view */
		if let rootview = super.rootView {
			let stackview = KCStackView()
			rootview.setup(childView: stackview)
			mStackView = stackview
		}
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
}

