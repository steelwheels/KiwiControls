/*
 * @file	TerminalViewController.swift
 * @brief	Define TerminalViewController class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiControls
import CoconutData
import CoconutShell
import Foundation

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

public class TerminalViewController: KCSingleViewController
{
	private var mTerminalView:	KCTerminalView? = nil
	private var mShell:		UTShellThread?  = nil

	open override func loadContext() -> KCView? {
		let termview = KCTerminalView()
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
		shell.terminalView = termview
		mTerminalView = termview

		#if true
			let box = KCStackView()
			box.axis = .vertical
			box.addArrangedSubView(subView: termview)
			return box
		#else
			return termview
		#endif
	}

	public override func viewDidAppear() {
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

		/* Receive key input */
		let inhdl = termview.inputFileHandle
		inhdl.readabilityHandler = {
			(_ hdl: FileHandle) -> Void in
			let data = hdl.availableData
			if let str = String.stringFromData(data: data) {
				NSLog("input data from keyboard: \(str)")
			} else {
				NSLog("Invalid data from keyboard")
			}
		}

		/* Print to output */
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
	}

}

