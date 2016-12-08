//
//  ViewController.swift
//  UTGraphicsEditor
//
//  Created by Tomoo Hamada on 2016/11/27.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import KiwiControls
import KiwiGraphics

class ViewController: NSViewController {

	@IBOutlet weak var mGraphicsView: KCLayerView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override func viewDidLayout() {
		super.viewDidLayout()

		let bounds = mGraphicsView.bounds
		let frame  = mGraphicsView.frame
		Swift.print("mGraphicsView: frame=\(frame.description), bounds=\(bounds.description)")
		let stroke = KCStrokeLayer(frame: bounds)
		stroke.backgroundColor = KGColorTable.blue.cgColor
		mGraphicsView.rootLayer.addSublayer(stroke)
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

