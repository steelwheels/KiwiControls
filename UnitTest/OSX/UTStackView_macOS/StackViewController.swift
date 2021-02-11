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
		button0.title = "Start"
		button0.buttonPressedCallback = {
			() -> Void in
			gr2d.start(interval: 1.0, endTime: 10.0)
		}
		hbox.addArrangedSubView(subView: button0)

		let button1   = KCButton()
		button1.title = "Stop"
		button1.buttonPressedCallback = {
			() -> Void in
			gr2d.stop()
		}

		let button2   = KCButton()
		button2.title = "Pause ON"
		button2.buttonPressedCallback = {
			() -> Void in
			switch gr2d.state {
			case .idle:
				NSLog("Unexpected state: \(gr2d.state.description)")
			case .pause:
				gr2d.resume()
				button2.title = "Pause ON"
			case .run:
				gr2d.suspend()
				button2.title = "Pause Off"
			}
		}

		hbox.addArrangedSubView(subView: button1)
		hbox.addArrangedSubView(subView: button2)
		vbox.addArrangedSubView(subView: hbox)

		return vbox
	}
}

public class UTGraphics2DView: KCGraphics2DView
{
	open override func draw(graphicsContext ctxt: CNGraphicsContext, count cnt: Int32) {
		let mod = cnt % 10
		let x   = -1.0 + (2.0 / CGFloat(mod + 1))

		ctxt.move(to: CGPoint(x: -1.0, y: -1.0))
		ctxt.line(to: CGPoint(x:    x, y:  1.0))
	}
}
