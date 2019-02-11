/**
 * @file	FirstViewController.swift
 * @brief	Define FirstViewController class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import KiwiControls
import UIKit

public class FirstViewController: KCSingleViewController
{
	public var mConsole = CNConsole()

	private var mURLLabel	: KCTextField?	= nil

	public override func loadView() {
		NSLog("FirstView: load view (init root view) at \(#function)")
		super.loadView()

		CNLogSetup(console: mConsole, doVerbose: true)

		let dmyrect   = KCRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)

		let label0    = KCTextField(frame: dmyrect)
		label0.text   = "Hello, world. This is label0"

		let button0   = KCButton(frame: dmyrect)
		button0.title = "OK"
		button0.buttonPressedCallback = {
			() -> Void in
			NSLog("FirstView: button pressed")
			self.selectInputFile()
		}

		let box0 = KCStackView(frame: dmyrect)
		box0.axis		= .horizontal
		box0.alignment		= .fill
		box0.distribution	= .fill // .fillEqually
		box0.addArrangedSubViews(subViews: [label0, button0])

		let label1 = KCTextField(frame: dmyrect)
		label1.text = "<No URL>"
		mURLLabel = label1

		let box1 = KCStackView(frame: dmyrect)
		box1.axis		= .vertical
		box1.alignment		= .fill
		box1.distribution	= .fill
		box1.addArrangedSubViews(subViews: [box0, label1])

		if let root = super.rootView {
			mConsole.print(string: "FirstView: setup root view")
			root.setup(childView: box1)

			let winsize  = KCLayouter.windowSize(viewController: self)
			let layouter = KCLayouter(viewController: self, console: mConsole, doVerbose: true)
			layouter.layout(rootView: root, windowSize: winsize)
		} else {
			fatalError("FirstView: No root view")
		}
	}

	public func selectInputFile() {
		let utis  = ["com.github.steelwheels.amber.application-package"]
		let panel = KCPanel(viewController: self, console: mConsole, doVerbose: true)
		panel.selectInputFile(title: "Hello", documentTypes: utis, completion: {
			(_ urlp: URL?) in
			if let url = urlp {
				self.mConsole.print(string: "FirstView: Open file selector ... OK \(url.absoluteString)")
				if let label = self.mURLLabel {
					label.text = url.absoluteString
					label.setNeedsDisplay()
					NSLog("FirstView: Update label by the URL")
				}
			} else {
				self.mConsole.print(string: "FirstView: Open file selector ... Cancelled")
			}
		})
	}

	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
}

