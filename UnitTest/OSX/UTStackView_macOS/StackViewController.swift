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
	open override func loadContext() -> KCView? {
		let vbox  = KCStackView()
		vbox.axis = .vertical

		let label = KCTextEdit()
		label.mode = .label
		label.text = "Label"
		vbox.addArrangedSubView(subView: label)

		let value = KCTextEdit()
		value.mode = .value(.decimal)
		value.text = "123.4"
		vbox.addArrangedSubView(subView: value)

		let textview = KCTextEdit()
		textview.mode = .value(.decimal)
		textview.text = "This is text for viewing"
		vbox.addArrangedSubView(subView: textview)

		let textedit = KCTextEdit()
		textedit.mode = .edit(40)
		textedit.text = "This is text for editing"
		vbox.addArrangedSubView(subView: textedit)

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

		return vbox
	}
}
