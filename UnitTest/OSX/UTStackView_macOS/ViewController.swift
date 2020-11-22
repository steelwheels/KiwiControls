//
//  ViewController.swift
//  UTStackView_macOS
//
//  Created by Tomoo Hamada on 2020/11/22.
//

import KiwiControls
import Cocoa

class ViewController: KCMultiViewController
{
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		let stack = StackViewController(parentViewController: self)
		self.pushViewController(viewController: stack)
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

