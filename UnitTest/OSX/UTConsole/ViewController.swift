//
//  ViewController.swift
//  UTConsole
//
//  Created by Tomoo Hamada on 2020/10/31.
//

import KiwiControls
import CoconutData
import Cocoa

class ViewController: KCPlaneViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let syspref = CNPreference.shared.systemPreference
		syspref.logLevel = .detail

		CNLog(logLevel: .error, message: "Hello, world !!")
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

