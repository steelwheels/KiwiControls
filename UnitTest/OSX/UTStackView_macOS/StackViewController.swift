/**
 * @file	StackViewController.swift
 * @brief	Define StackViewController class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiControls
import Foundation

public class StackViewController: KCSingleViewController
{
	open override func loadViewContext(rootView root: KCRootView) {
		let vbox  = KCStackView()
		vbox.axis = .vertical

		let label = KCTextField()
		label.text = "Label0"
		vbox.addArrangedSubView(subView: label)

		let terminal = KCTerminalView()
		vbox.addArrangedSubView(subView: terminal)

		let hbox = KCStackView()
		hbox.axis = .horizontal
		let button0   = KCButton()
		button0.title = "OK"
		hbox.addArrangedSubView(subView: button0)
		let button1   = KCButton()
		button1.title = "Cancel"
		hbox.addArrangedSubView(subView: button1)
		vbox.addArrangedSubView(subView: hbox)

		root.setup(childView: vbox)
	}
}
