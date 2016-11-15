//
//  ViewController.swift
//  UTCoodinateTest
//
//  Created by Tomoo Hamada on 2016/11/09.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import UIKit
import KiwiControls

class ViewController: UIViewController {

	static private let DO_DEBUG = false

	@IBOutlet weak var mGraphicsView: KCGraphicsView!
	private var	   mGraphicsDrawer = KCGraphicsDrawer()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		let bounds = mGraphicsView.bounds

		/* Add drawer */
		let debugger = DebugLayer(bounds: bounds)
		mGraphicsDrawer.addLayer(layer: debugger)

		mGraphicsView!.drawCallback = {
			(context:CGContext, bounds:CGRect, dirtyRect:CGRect) -> Void in
			if ViewController.DO_DEBUG {
				Swift.print("ViewController.drawCallback: bounds:\(bounds.description) dirty:\(dirtyRect.description)")
			}
			self.mGraphicsDrawer.drawContent(context: context, bounds: bounds, dirtyRect: dirtyRect)
		}

		mGraphicsView!.mouseEventCallback = {
			(event: KCMouseEvent, point: CGPoint) -> CGRect in
			return self.mGraphicsDrawer.mouseEvent(event: event, at: point)
		}
	}
}

