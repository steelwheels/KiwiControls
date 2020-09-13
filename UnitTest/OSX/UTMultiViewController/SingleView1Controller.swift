/**
 * @file SingleView1Controller.swift
 * @brief Define SingleView1Controller. class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import KiwiControls
import Foundation

public class SingleView1Controller: KCSingleViewController
{
	private var mTerminalView:	KCTerminalView? = nil

	public override func loadViewContext(rootView root: KCRootView) -> KCSize {
		let terminal  = KCTerminalView()
		terminal.outputFileHandle.write(string: "Good, morning !!")
		mTerminalView = terminal

		//let console = KCConsoleView()
		//console.consoleConnection.print(string: "Hello, world !!")

		let box0 = KCStackView(frame: KCRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
		box0.addArrangedSubViews(subViews: [terminal])
		//box0.addArrangedSubViews(subViews: [console])
		box0.axis = .vertical
		box0.distribution = .fillEqually
		box0.alignment = .center

		root.setup(childView: box0)

		return box0.fittingSize
	}

	public override func viewDidLoad() {
		CNLog(logLevel: .debug, message: "viewDidLoad")
		super.viewDidLoad()
		doDumpView(message: "After viewDidLoad")
	}

	#if os(OSX)
	public override func viewWillAppear() {
		CNLog(logLevel: .debug, message: "viewWillAppear")
		super.viewWillAppear()
		doDumpView(message: "After viewWillAppear")
	}
	#else
	public override func viewWillAppear(_ animated: Bool) {
		CNLog(logLevel: .debug, message: "viewWillAppear")
		super.viewWillAppear(animated)
		doDumpView(message: "After viewWillAppear")
	}
	#endif

	#if os(OSX)
	public override func viewDidAppear() {
		CNLog(logLevel: .debug, message: "viewDidAppear")
		super.viewDidAppear()
		doDumpView(message: "After viewDidAppear")

		/* Update terminal size */
		if let termview = mTerminalView {
			termview.currentColumnNumbers = 10
		}
	}
	#else
	public override func viewDidAppear(_ animated: Bool) {
		log(type: .debug, string: "viewDidAppear", file: #file, line: #line, function: #function)
		super.viewDidAppear(animated)
		doDumpView(message: "After viewDidAppear")
	}
	#endif

	private func doDumpView(message msg: String){
		if let view = self.rootView {
			CNLog(logLevel: .debug, message: msg)
			let dumper = KCViewDumper()
			dumper.dump(view: view)
		} else {
			fatalError("No root view")
		}
	}
}

