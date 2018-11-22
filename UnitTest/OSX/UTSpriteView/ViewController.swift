//
//  ViewController.swift
//  UTSpriteView
//
//  Created by Tomoo Hamada on 2018/11/22.
//  Copyright © 2018 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import Cocoa

class ViewController: NSViewController {

	@IBOutlet weak var mSpriteView: KCSpriteView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		mSpriteView.backgroundColor = .yellow
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

