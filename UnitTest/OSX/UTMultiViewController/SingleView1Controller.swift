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
	private var mConsole = CNFileConsole()

	public override func loadView() {
		CNLog(type: .Normal, message: "loadView", place: #file)
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
			CNLog(type: .Normal, message: "setup root view", place: #file)
			root.setup(childView: box0)

			let layouter = KCLayouter(viewController: self, console: mConsole, doVerbose: true)
			layouter.layout(rootView: root)
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

