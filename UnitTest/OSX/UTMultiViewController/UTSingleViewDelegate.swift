/**
 * @file UTSingleViewDelegate.swift
 * @brief Define UTSingleViewDelegate class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiControls
import Foundation

public class UTSingleViewController: KCSingleViewController
{
	public override func loadView() {
		NSLog("\(#function): load view (init root view)")
		super.loadView()
		let label0    = KCTextField(frame: KCRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
		label0.text   = "Hello, world. This is label0"
		if let root = super.rootView {
			NSLog("\(#function): setup root view")
			root.setup(childView: label0)
		} else {
			fatalError("No root view")
		}
	}

	public override func viewDidLoad() {
		super.viewDidLoad()
		NSLog("\(#function): viewDidLoad")

	}

	#if os(OSX)
	public override func viewWillAppear() {
		super.viewWillAppear()
		NSLog("\(#function): viewWillAppear")
		if let root = super.rootView {
			NSLog("viewWillAppear: size=\(root.frame.size)")
		}
	}
	#else
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NSLog("\(#function): viewWillAppear")
		if let root = super.rootView {
			NSLog("viewWillAppear: size=\(root.frame.size)")
		}
	}
	#endif
}

