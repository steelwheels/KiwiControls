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

	public override func loadView() {
		super.loadView()

		CNLog(type: .Normal, message: "loadView", place: #file)

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

		if let root = super.rootView {
			mConsole.print(string: "\(#function): setup root view\n")
			root.setup(childView: box0)
		} else {
			fatalError("No root view")
		}
		doDumpView(message: "After loadView")
	}

	public override func viewDidLoad() {
		CNLog(type: .Normal, message: "viewDidLoad", place: #file)
		super.viewDidLoad()
		doDumpView(message: "After viewDidLoad")
	}

	#if os(OSX)
	public override func viewWillAppear() {
		CNLog(type: .Normal, message: "viewWillAppear", place: #file)
		super.viewWillAppear()
		doDumpView(message: "After viewWillAppear")
	}
	#else
	public override func viewWillAppear(_ animated: Bool) {
		CNLog(type: .Normal, message: "viewWillAppear", place: #file)
		super.viewWillAppear(animated)
		doDumpView(message: "After viewWillAppear")
	}
	#endif

	#if os(OSX)
	public override func viewDidAppear() {
		CNLog(type: .Normal, message: "viewDidAppear", place: #file)
		super.viewDidAppear()
		doDumpView(message: "After viewDidAppear")
	}
	#else
	public override func viewDidAppear(_ animated: Bool) {
		CNLog(type: .Normal, message: "viewDidAppear", place: #file)
		super.viewDidAppear(animated)
		doDumpView(message: "After viewDidAppear")
	}
	#endif

	private func doDumpView(message msg: String){
		if let view = self.rootView {
			mConsole.print(string: "///// \(msg)\n")
			let dumper = KCViewDumper(console: mConsole)
			dumper.dump(view: view)
		} else {
			fatalError("No root view")
		}
	}
}


