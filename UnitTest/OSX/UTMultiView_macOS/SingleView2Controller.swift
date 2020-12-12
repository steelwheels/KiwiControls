/**
 * @file SingleView2Controller.swift
 * @brief Define SingleView2Controller. class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import KiwiControls
import Foundation

public class SingleView2Controller: KCSingleViewController
{
	private var mConsole = CNFileConsole()

	public override func loadContext() -> KCView? {
		CNLog(logLevel: .debug, message: "loadView")

		let dummyrect = KCRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)

		let label0    = KCTextField(frame: dummyrect)
		label0.text   = "Hello, world. This is label0"

		let text0     = KCTextEdit(frame: dummyrect)
		text0.text    = ""

		let button0   = KCButton(frame: dummyrect)
		button0.title = "Press me"

		let box0 = KCStackView(frame: dummyrect)
		if false {
			box0.axis = .vertical
		} else {
			box0.axis = .horizontal
		}
		box0.alignment = .leading
		mConsole.print(string: "box0.alignment = " + box0.axis.description + "\n")
		box0.distribution = .fillEqually
		box0.addArrangedSubViews(subViews: [label0, text0, button0])

		return box0
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
	}
	#else
	public override func viewDidAppear(_ animated: Bool) {
		CNLog(logLevel: .debug, message: "viewDidAppear")
		CNLog(type: .Normal, message: "viewDidAppear", place: #file)
		super.viewDidAppear(animated)
		doDumpView(message: "After viewDidAppear")
	}
	#endif

	private func doDumpView(message msg: String){
		if let view = self.rootView {
			if CNPreference.shared.systemPreference.logLevel.isIncluded(in: .debug) {
				if let cons = KCLogManager.shared.console {
					cons.print(string: msg + "\n")
					let dumper = KCViewDumper()
					dumper.dump(view: view, console: cons)
				} else {
					NSLog("No log console")
				}
			}
		} else {
			fatalError("No root view")
		}
	}
}


