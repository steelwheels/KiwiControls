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
		NSLog("\(#function): load view (init root view)")
		super.loadView()

		let dummyrect = KCRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)

		let label0    = KCTextField(frame: dummyrect)
		label0.text   = "Hello, world. This is label0"

		let button0   = KCButton(frame: dummyrect)
		button0.title = "Press me"

		let box0 = KCStackView(frame: dummyrect)
		box0.addArrangedSubViews(subViews: [label0, button0])
		box0.alignment = .horizontal(align: .middle)

		if let root = super.rootView {
			NSLog("\(#function): setup root view")
			root.setup(viewController: self, childView: box0)
		} else {
			fatalError("No root view")
		}
	}

	public override func viewDidLoad() {
		NSLog("\(#function): viewDidLoad")
		super.viewDidLoad()
	}

	#if os(OSX)
	public override func viewWillAppear() {
		NSLog("\(#function): viewWillAppear")
		super.viewWillAppear()
		doDumpView()
	}
	#else
	public override func viewWillAppear(_ animated: Bool) {
		NSLog("\(#function): viewWillAppear")
		super.viewWillAppear(animated)
		doDumpView()
	}
	#endif

	#if os(OSX)
	public override func viewDidAppear() {
		NSLog("\(#function): viewDidAppear")
		super.viewDidAppear()
		doDumpView()
	}
	#else
	public override func viewDidAppear(_ animated: Bool) {
		NSLog("\(#function): viewDidAppear")
		super.viewDidAppear(animated)
		doDumpView()
	}
	#endif

	private func doDumpView(){
		if let view = self.rootView {
			let dumper = KCViewDumper(console: mConsole)
			dumper.dump(view: view)
		} else {
			fatalError("No root view")
		}
	}
}

