//
//  ViewController.swift
//  UTStackView
//
//  Created by Tomoo Hamada on 2017/04/23.
//  Copyright © 2017年 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import Cocoa

class ViewController: NSViewController
{
	@IBOutlet weak var mStackView: KCStackView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

