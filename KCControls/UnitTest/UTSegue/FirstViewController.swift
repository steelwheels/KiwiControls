//
//  FirstViewController.swift
//  UTSegue
//
//  Created by Tomoo Hamada on 2015/11/14.
//  Copyright © 2015年 Steel Wheels Project. All rights reserved.
//

import Cocoa

class FirstViewController: NSViewController {

	@IBOutlet weak var moveToSecondButton: NSButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}
	
	@IBAction func pressMoveToSecondButton(sender: AnyObject) {
		performSegueWithIdentifier("FirstToSecond", sender: self)
	}
}

