/**
 * @file SingleView0Controller.swift
 * @brief Define SingleView0Controller. class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import KiwiControls
import Foundation

public class SingleView0Controller: KCSingleViewController
{
	public override func loadView() {
		super.loadView()
		
		let dmyrect   = KCRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)

		let label0    = KCTextField(frame: dmyrect)
		label0.text   = "Hello, world. This is label0"

		let button0   = KCButton(frame: dmyrect)
		button0.title = "OK"

		let box0 = KCStackView(frame: dmyrect)
		box0.axis		= .horizontal
		box0.alignment		= .fill
		box0.distribution	= .fill // .fillEqually
		box0.addArrangedSubViews(subViews: [label0, button0])

		let edit1 = KCTextEdit(frame: dmyrect)
		let box1  = KCStackView(frame: dmyrect)
		box1.axis		= .vertical
		box1.alignment		= .fill
		box1.distribution	= .fill
		box1.addArrangedSubViews(subViews: [box0, edit1])

		if let root = super.rootView {
			log(type: .flow, string: "setup root view", file: #file, line: #line, function: #function)
			root.setup(childView: box1)
		} else {
			fatalError("No root view")
		}
	}

	public override func viewDidLoad() {
		log(type: .flow, string: "viewDidLoad", file: #file, line: #line, function: #function)
		super.viewDidLoad()
	}

	#if os(OSX)
	public override func viewWillAppear() {
		log(type: .flow, string: "viewWillAppear", file: #file, line: #line, function: #function)
		super.viewWillAppear()
		doDumpView(message: "Last viewWillAppear")
	}
	#else
	public override func viewWillAppear(_ animated: Bool) {
		log(type: .Flow, string: "viewWillAppear", file: #file, line: #line, function: #function)
		super.viewWillAppear(animated)
		doDumpView(message: "Last viewWillAppear")
	}
	#endif

	#if os(OSX)
	public override func viewDidAppear() {
		log(type: .flow, string: "viewDidAppear", file: #file, line: #line, function: #function)
		super.viewDidAppear()
		doDumpView(message: "Last viewDidAppear")
	}
	#else
	public override func viewDidAppear(_ animated: Bool) {
		log(type: .Flow, string: "viewDidAppear", file: #file, line: #line, function: #function)
		super.viewDidAppear(animated)
		doDumpView(message: "Last viewDidAppear")
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

