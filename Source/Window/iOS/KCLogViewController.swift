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
		stack.distribution = .fillProportinally

		/* Allocate navigation bar to stack */
		let navigation = KCNavigationBar(frame: dmyrect)
		navigation.title			= "Log console"
		navigation.isRightButtonEnabled		= true
		navigation.rightButtonTitle		= "Back"
		navigation.rightButtonPressedCallback	= {
			[weak self] () -> Void in
			if let myself = self {
				let parent = myself.parentController
				if !parent.popViewController(returnValue: .nullValue) {
					myself.mConsole.error(string: "Can not pop previous view at \(#file)/\(#line)/\(#function)")
				}
			}
		}
		stack.addArrangedSubView(subView: navigation)

		/* Add text field */
		let consoleview = KCConsoleView()
		stack.addArrangedSubView(subView: consoleview)

		if let root = super.rootView {
			let standards = CNStandardFiles.shared

			root.setup(childView: stack)
			mConsoleView = consoleview
			mConsole.outputConsole = CNFileConsole(input:  standards.input,
							       output: consoleview.outputFile,
							       error:  consoleview.errorFile)
		} else {
			CNLog(logLevel: .detail, message: "Can not allocate console view", atFunction: #function, inFile: #file)
		}
	}

	public var consoleConnection: CNConsole {
		get { return mConsole }
	}
}


