//
//  ViewController.swift
//  UTSimpleTerminal
//
//  Created by Tomoo Hamada on 2020/11/19.
//

import KiwiControls
import CoconutShell
import CoconutData
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

class ViewController: NSViewController, KCViewControlEventReceiver {

	@IBOutlet private var mRootView: KCRootView!

	private var mShell:	CNShellThread? = nil

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		let termview = KCTerminalView()
		mRootView.setup(childView: termview)

		/* Allocate shell */
		NSLog("Launch terminal")
		let procmgr : CNProcessManager = CNProcessManager()
		let instrm  : CNFileStream     = .fileHandle(termview.inputFileHandle)
		let outstrm : CNFileStream     = .fileHandle(termview.outputFileHandle)
		let errstrm : CNFileStream     = .fileHandle(termview.errorFileHandle)
		let environment		       = CNEnvironment()
		NSLog("Allocate shell")
		let shell     = UTShellThread(processManager: procmgr, input: instrm, output: outstrm, error: errstrm, environment: environment)
		shell.terminalView = termview

		mShell = shell
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	open override func viewWillLayout() {
		NSLog("viewWillLayout")
		super.viewWillLayout()
		//mRootView.updateContentSize()
	}

	open override func viewDidLayout() {
		NSLog("viewDidLayout")
		super.viewDidLayout()
		//let dumper = KCViewDumper()
		//dumper.dump(view: mRootView)
	}

	public func updateWindowSize(viewControlEvent event: KCViewControlEvent) {
		if let root = mRootView {
			switch event {
			case .none:
				break
			case .updateWindowSize:
				root.requireLayout()
			}
		} else {
			NSLog("updateWindowSize ... skipped")
		}
	}
}

