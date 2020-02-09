/**
 * @file	SingleViewController.swift
 * @brief	Define SingleViewController class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiControls
import CoconutData
import UIKit

class SingleViewController: KCSingleViewController
{
	open override func loadView() {
		super.loadView()

		let stackview = KCStackView()
		stackview.axis = .vertical

		let colselector = KCColorSelector()
		colselector.setLabel(string: "Text color:")
		stackview.addArrangedSubView(subView: colselector)

		if let root = super.rootView {
			root.setup(childView: stackview)
		} else {
			NSLog("Failed to set controls")
		}
	}
}

