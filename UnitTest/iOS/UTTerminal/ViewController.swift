//
//  ViewController.swift
//  UTTerminal
//
//  Created by Tomoo Hamada on 2020/01/25.
//  Copyright © 2020 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import CoconutData
import UIKit

class ViewController: UIViewController
{
	@IBOutlet weak var mTerminalView: KCTerminalView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		let size = self.view.frame.size
		mTerminalView.resize(size)
	}

	override func viewDidAppear(_ doanimate: Bool) {
		super.viewDidAppear(doanimate)
		mTerminalView.outputFileHandle.write(string: "Hello, world !!")
	}
}

