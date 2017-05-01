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
	}

	override func viewDidLayout() {
		let origin = mStackView.frame.origin
		let size   = mStackView.frame.size

		let button0 = KCButton(frame: NSRect(origin: origin, size: CGSize(width: size.width, height: 32.0)))
		button0.title = "Button-0"
		mStackView.addSubview(button0)

		let button1 = KCButton(frame: NSRect(origin: CGPoint(x: origin.x, y:origin.y+32), size: CGSize(width: size.width, height: 32.0)))
		button1.title = "Button-1"
		mStackView.addSubview(button1)

		mStackView.setViews(views:[button0, button1])
		mStackView.printDebugInfo(indent: 0)
		
		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

