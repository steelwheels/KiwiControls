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
	open override func loadViewContext(rootView root: KCRootView) -> KCSize {
		let prefview = KCTerminalPreferenceView()
		root.setup(childView: prefview)
		let prefsize = KCMaxSize(sizeA: prefview.fittingSize, sizeB: KCSize(width: 640, height: 480))
		NSLog("PreferenceView: size=\(prefsize)")
		return prefsize
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	public override func viewWillDisappear() {
		if let window = self.view.window as? KCPreferenceWindow {
			if window.didCancelled {
				NSLog("viewWillDisappear: Cancelled")
			} else {
				NSLog("viewWillDisappear: Save preference")
			}
		} else {
			NSLog("viewWillDisappear: No window")
		}
	}

	public override func viewDidAppear() {
		super.viewDidAppear()

		let _ = KCLogManager.shared
		CNPreference.shared.systemPreference.logLevel = .debug
	}
}

