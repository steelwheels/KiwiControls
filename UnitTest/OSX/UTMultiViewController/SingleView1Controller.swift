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
	public override func loadView() {
		super.loadView()

		let terminal  = KCTerminalView()
		terminal.outputFileHandle.write(string: "Good, morning !!")

		//let console = KCConsoleView()
		//console.consoleConnection.print(string: "Hello, world !!")

		let box0 = KCStackView(frame: KCRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
		box0.addArrangedSubViews(subViews: [terminal])
		//box0.addArrangedSubViews(subViews: [console])
		box0.axis = .vertical
		box0.distribution = .fill
		box0.alignment = .center

		if let root = super.rootView {
			log(type: .flow, string: "setup root view", file: #file, line: #line, function: #function)
			root.setup(childView: box0)
		} else {
			fatalError("No root view")
		}
		doDumpView(message: "After loadView")
	}

	public override func viewDidLoad() {
		log(type: .flow, string: "viewDidLoad", file: #file, line: #line, function: #function)
		super.viewDidLoad()
		doDumpView(message: "After viewDidLoad")
	}

	#if os(OSX)
	public override func viewWillAppear() {
		log(type: .flow, string: "viewWillAppear", file: #file, line: #line, function: #function)
		super.viewWillAppear()
		doDumpView(message: "After viewWillAppear")
	}
	#else
	public override func viewWillAppear(_ animated: Bool) {
		log(type: .flow, string: "viewWillAppear", file: #file, line: #line, function: #function)
		super.viewWillAppear(animated)
		doDumpView(message: "After viewWillAppear")
	}
	#endif

	#if os(OSX)
	public override func viewDidAppear() {
		log(type: .flow, string: "viewDidAppear", file: #file, line: #line, function: #function)
		super.viewDidAppear()
		doDumpView(message: "After viewDidAppear")
	}
	#else
	public override func viewDidAppear(_ animated: Bool) {
		log(type: .flow, string: "viewDidAppear", file: #file, line: #line, function: #function)
		super.viewDidAppear(animated)
		doDumpView(message: "After viewDidAppear")
	}
	#endif

	private func doDumpView(message msg: String){
		if let view = self.rootView {
			log(type: .flow, string: msg, file: #file, line: #line, function: #function)
			let dumper = KCViewDumper(console: console!)
			dumper.dump(view: view)
		} else {
			fatalError("No root view")
		}
	}
}

