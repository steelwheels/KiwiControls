//
//  ViewController.swift
//  UTStackView_macOS
//
//  Created by Tomoo Hamada on 2020/11/22.
//

import KiwiControls
import CoconutData
import Cocoa

class ViewController: KCMultiViewController
{
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		let stack = StackViewController(parentViewController: self)
		let cbfunc: KCMultiViewController.ViewSwitchCallback = {
			(_ val: CNNativeValue) -> Void in
			let message: String
			if let str = val.toString() {
				message = str
			} else {
				message = "<uknown>"
			}
			NSLog("view is poped: \(message)")
		}
		self.pushViewController(viewController: stack, callback: cbfunc)
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

