//
//  ViewController.swift
//  UTGraphicsView
//
//  Created by Tomoo Hamada on 2016/09/12.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import KiwiControls
import KiwiGraphics

class ViewController: NSViewController {

	@IBOutlet weak var mGraphicsView: KCGraphicsView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		mGraphicsView.drawCallback = {
			(_ context:CGContext, _ bounds:CGRect, _ dirtyRect:CGRect) -> Void in

			let eclipse = KGEclipse(center: bounds.center, innerRadius: 20.0, outerRadius: 40.0)
			context.draw(eclipse: eclipse)

			//context.addRect(dirtyRect)
			//context.fillPath()
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

