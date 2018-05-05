//
//  ViewController.swift
//  UTRootView
//
//  Created by Tomoo Hamada on 2018/05/05.
//  Copyright © 2018年 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import Cocoa

class ViewController: NSViewController
{
	@IBOutlet weak var mRootView: KCRootView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		let button = KCButton()
		mRootView.setupContext(childView: button)
	}

	override func viewDidAppear() {
		super.viewDidAppear()
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

