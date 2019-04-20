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
		
		let label0    = KCTextField(frame: KCRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
		label0.text   = "Hello, world. This is label0"

		let label1    = KCTextField(frame: KCRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
		label1.text   = "Goodmorning, world. This is label1"

		let box0 = KCStackView(frame: KCRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
		box0.addArrangedSubViews(subViews: [label0, label1])
		box0.axis = .vertical
		box0.distribution = .fill
		box0.alignment = .center

		if let root = super.rootView {
			log(type: .Flow, string: "setup root view", file: #file, line: #line, function: #function)
			root.setup(childView: box0)

			let winsize  = KCLayouter.windowSize(viewController: self, console: logConsole)
			let layouter = KCLayouter(viewController: self, console: logConsole, doVerbose: true)
			layouter.layout(rootView: root, windowSize: winsize)
		} else {
			fatalError("No root view")
		}
		doDumpView(message: "After loadView")
	}

	public override func viewDidLoad() {
		log(type: .Flow, string: "viewDidLoad", file: #file, line: #line, function: #function)
		super.viewDidLoad()
		doDumpView(message: "After viewDidLoad")
	}

	#if os(OSX)
	public override func viewWillAppear() {
		log(type: .Flow, string: "viewWillAppear", file: #file, line: #line, function: #function)
		super.viewWillAppear()
		doDumpView(message: "After viewWillAppear")
	}
	#else
	public override func viewWillAppear(_ animated: Bool) {
		log(type: .Flow, string: "viewWillAppear", file: #file, line: #line, function: #function)
		super.viewWillAppear(animated)
		doDumpView(message: "After viewWillAppear")
	}
	#endif

	#if os(OSX)
	public override func viewDidAppear() {
		log(type: .Flow, string: "viewDidAppear", file: #file, line: #line, function: #function)
		super.viewDidAppear()
		doDumpView(message: "After viewDidAppear")
	}
	#else
	public override func viewDidAppear(_ animated: Bool) {
		log(type: .Flow, string: "viewDidAppear", file: #file, line: #line, function: #function)
		super.viewDidAppear(animated)
		doDumpView(message: "After viewDidAppear")
	}
	#endif

	private func doDumpView(message msg: String){
		if let view = self.rootView {
			log(type: .Flow, string: msg, file: #file, line: #line, function: #function)
			let dumper = KCViewDumper(console: logConsole)
			dumper.dump(type: .Flow, view: view)
		} else {
			fatalError("No root view")
		}
	}
}

