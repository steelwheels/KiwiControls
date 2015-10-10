//
//  ViewController.swift
//  UTConsoleView
//
//  Created by Tomoo Hamada on 2015/08/02.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import KCConsoleView

class ViewController: NSViewController {

	@IBOutlet weak var consoleView: KCConsoleView! ;
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		if let view = consoleView {
			view.appendText("Hello, World\nGood evening\n") ;
			
			let console = KCConsole(view: view)
			console.putString("Good morning")
			console.putNewline()
			console.incIndent()
			console.putString("Good afternoon")
			console.putNewline()
			console.decIndent()
			console.putString("Good bye")
		}
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

