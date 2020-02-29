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

