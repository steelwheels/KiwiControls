/**
 * @file ViewController.swift
 * @brief Define ViewController class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import KiwiControls
import CoconutData
import Cocoa

class ViewController: KCMultiViewController
{
	open override func viewDidLoad() {
		super.viewDidLoad()

		let cont1 = SingleViewController(parentViewController: self)
		self.pushViewController(viewController: cont1, callback: {
			(_ val: CNValue) -> Void in
		})

	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}
