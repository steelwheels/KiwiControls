/**
 * @file	ViewController.swift
 * @brief	View controller for UTControl
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Cocoa
import CoconutData
import KiwiControls

class ViewController: KCPlaneViewController
{
	override func loadView() {
		super.loadView()

		/* Allocate preference view */
		if let rootview = super.rootView {
			let prefview = KCTerminalPreferenceView()
			rootview.setup(childView: prefview)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	public override func viewDidAppear() {
		super.viewDidAppear()
	}
}

/*
/**
 * @file	SingleViewController.swift
 * @brief	Define SingleViewController class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiControls
import CoconutData
import Cocoa

class SingleViewController: KCSingleViewController
{
	open override func loadView() {
		super.loadView()
		if false {
			setupColorSelectorView()
		} else {
			setupPreferenceView()
		}
	}

	private func setupColorSelectorView() {
		let selview = KCColorSelector()
		selview.callbackFunc = {
			(_ color: KCColor) in
			NSLog("Update text color")
		}
		if let root = super.rootView {
			root.setup(childView: selview)
		} else {
			NSLog("Failed to set controls")
		}
	}

	private func setupPreferenceView() {
		let prefview = KCTerminalPreferenceView()
		#if false
		if let cons = super.console {
			let dumper = KCViewDumper(console: cons)
			dumper.dump(view: prefview)
		}
		#endif
		if let root = super.rootView {
			NSLog("Load preference view")
			root.setup(childView: prefview)
		} else {
			NSLog("Failed to set controls")
		}
	}
}


*/

