//
//  ViewController.swift
//  UTConsoleView
//
//  Created by Tomoo Hamada on 2015/08/02.
//  Copyright (c) 2015年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import KCConsoleView
import Canary

class ViewController: NSViewController {

	@IBOutlet weak var consoleView: KCConsoleView! ;
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		if let view = consoleView {
			let text0 = CNConsoleText(string: "Hello, World\nGood evening\n")
			view.appendText(text: text0)
			
			let console = KCConsole(view: view)
			console.print(string: "Good morning\n")
			console.print(string: "  Good afternoon\n")
			console.print(string: "Good bye : ")
			
			let word1 = CNConsoleWord(string: "Red String\n", attribute:
				[NSForegroundColorAttributeName: NSColor.redColor()])
			let text1 = CNConsoleText(word: word1)
			console.print(text: text1)
		}
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

