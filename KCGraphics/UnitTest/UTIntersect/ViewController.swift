//
//  ViewController.swift
//  UTIntersect
//
//  Created by Tomoo Hamada on 2016/05/07.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import KCConsoleView

class ViewController: NSViewController
{
	@IBOutlet weak var consoleView: KCConsoleView!
	
	private var testCollision:  UTCollision? = nil
	private var testReflection: UTReflection? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		let console = KCConsole(view: consoleView)
		console.print(string: "Hello, World\n")
		
		var result: Bool = true
		
		testCollision = UTCollision(console: console)
		result = testCollision!.executeTest() && result
		
		testReflection = UTReflection(console: console)
		result = testReflection!.executeTest() && result
		
		if result {
			Swift.print("[SUMMARY] OK")
		} else {
			Swift.print("[SUMMARY] NG")
		}
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

