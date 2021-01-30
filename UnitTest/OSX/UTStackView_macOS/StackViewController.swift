/**
 * @file	StackViewController.swift
 * @brief	Define StackViewController class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiControls
import CoconutData
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

		let gr2d = UTGraphics2DView()
		gr2d.minimumSize  = KCSize(width: 256.0, height: 256.0)
		gr2d.logicalFrame = CGRect(x: -1.0, y: -1.0, width: 2.0, height: 2.0)
		vbox.addArrangedSubView(subView: gr2d)

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

public class UTGraphics2DView: KCGraphics2DView
{
	open override func draw(context ctxt: CNGraphicsContext) {
		NSLog("[UTGraphics2DView] draw")
		ctxt.move(to: CGPoint(x: -1.0, y: -1.0))
		ctxt.line(to: CGPoint(x:  1.0, y:  1.0))
	}
}
