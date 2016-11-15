//
//  ViewController.swift
//  UTGraphicsLayer
//
//  Created by Tomoo Hamada on 2016/10/09.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import KiwiGraphics
import KiwiControls

class ViewController: NSViewController
{
	@IBOutlet weak var mGraphicsView: KCGraphicsView!

	private var mGraphicsDrawer = KCGraphicsDrawer()

	override func viewDidLayout() {
		super.viewDidLayout()

		// Do any additional setup after loading the view.
		mGraphicsView.drawCallback = {
			(_ context:CGContext, _ bounds:CGRect, _ dirtyRect:CGRect) -> Void in
				self.mGraphicsDrawer.drawContent(context: context, bounds: bounds, dirtyRect: dirtyRect)
		}
		mGraphicsView.mouseEventCallback = {
			(_ event: KCMouseEvent, _ point: CGPoint) -> KCMouseEventResult in
				self.mGraphicsDrawer.mouseEvent(event: event, at: point)
		}

		let bounds = mGraphicsView.bounds
		let background = KCBackgroundDrawer(bounds: bounds)
		background.color = CGColor.black
		mGraphicsDrawer.addLayer(layer: background)

		mGraphicsDrawer.addLayer(layer: UTVertexLayer(bounds: bounds))
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}
