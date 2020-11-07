/**
 * @file ViewController.swift
 * @brief Define ViewController class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import KiwiControls
import CoconutData
import CoconutShell
import Cocoa


open class UTShellThread: CNShellThread
{
	public var terminalView: KCTerminalView? = nil

	open override func execute(command cmd: String) -> Bool {
		#if false
		CNExecuteInMainThread(doSync: true, execute: {
			() -> Void in
			if let view = self.terminalView {
				let offset = view.verticalOffset()
				self.console.print(string: "vOffset = \(offset)\n")
			}
		})
		#endif
		return super.execute(command: cmd)
	}
}

class ViewController: KCPlaneViewController
{
	private var	mTerminalView:	KCTerminalView? = nil
	private var	mShell: CNShellThread? = nil

	open override func loadViewContext(rootView root: KCRootView) -> KCSize? {
		let termview = KCTerminalView()
		root.setup(childView: termview)
		mTerminalView = termview

		/* Allocate shell */
		NSLog("Launch terminal")
		let procmgr : CNProcessManager = CNProcessManager()
		let instrm  : CNFileStream     = .fileHandle(termview.inputFileHandle)
		let outstrm : CNFileStream     = .fileHandle(termview.outputFileHandle)
		let errstrm : CNFileStream     = .fileHandle(termview.errorFileHandle)
		let environment		       = CNEnvironment()
		NSLog("Allocate shell")
		let shell     = UTShellThread(processManager: procmgr, input: instrm, output: outstrm, error: errstrm, environment: environment)
		mShell        = shell
		shell.terminalView = mTerminalView
		
		return termview.fittingSize
	}

	override func viewWillLayout() {
		NSLog("viewWillLayout")
		super.viewWillLayout()
	}

	override func viewDidAppear() {
		super.viewDidAppear()

		guard let termview = mTerminalView else {
			NSLog("No terminal view")
			return
		}

		/* Start shell */
		if let shell = mShell {
			NSLog("start shell")
			shell.start(argument: .nullValue)
		}

		/* Update size */
		NSLog("Request to update the size of terminal")
		termview.currentColumnNumbers	= 80
		termview.currentRowNumbers	= 25

		let red = CNEscapeCode.foregroundColor(CNColor.red).encode()
		termview.outputFileHandle.write(string: red + "Red\n")

		let blue = CNEscapeCode.foregroundColor(CNColor.blue).encode()
		termview.outputFileHandle.write(string: blue + "Blue\n")

		let green = CNEscapeCode.foregroundColor(CNColor.green).encode()
		termview.outputFileHandle.write(string: green + "Green\n")

		let reset = CNEscapeCode.resetCharacterAttribute.encode()
		let under = CNEscapeCode.underlineCharacter(true).encode()
		termview.outputFileHandle.write(string: reset + under + "Underline\n")

		let bold = CNEscapeCode.boldCharacter(true).encode()
		termview.outputFileHandle.write(string: bold + "Bold\n")

		termview.outputFileHandle.write(string: reset)

		/* Enable logging */
		CNPreference.shared.systemPreference.logLevel = .error
		CNLog(logLevel: .error, message: "Hello Log Message !!")
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

