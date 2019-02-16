/**
 * @file	KCLogViewController.swift
 * @brief	Define KCLogViewController class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

open class KCLogViewController: KCSingleViewController
{
	private var mConsoleView: KCConsoleView?    = nil
	private var mConsole:	  CNBufferedConsole = CNBufferedConsole()

	open override func loadView() {
		/* Setup root view */
		super.loadView()

		/* allocate stack */
		let dmyrect = KCRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
		let stack   = KCStackView(frame: dmyrect)
		stack.axis         = .vertical
		stack.alignment    = .fill
		stack.distribution = .fill

		/* Allocate navigation bar to stack */
		let navigation = KCNavigationBar(frame: dmyrect)
		navigation.title			= "Log console"
		navigation.isRightButtonEnabled		= true
		navigation.rightButtonTitle		= "Back"
		navigation.rightButtonPressedCallback	= {
			() -> Void in
			if let parent = self.parentController {
				if !parent.popViewController() {
					CNLog(type: .Error, message: "Can not pop previous view", place: #function)
				}
			}
		}
		stack.addArrangedSubView(subView: navigation)

		/* Add text field */
		let console = KCConsoleView()
		stack.addArrangedSubView(subView: console)

		if let root = super.rootView {
			root.setup(childView: stack)
			mConsoleView = console
			mConsole.outputConsole = console.console
		} else {
			NSLog("\(#function) [Error] Can not allocate console view")
		}
	}
}


