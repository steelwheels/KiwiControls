//
//  ViewController.swift
//  UTRepetitiveDrawer
//
//  Created by Tomoo Hamada on 2016/10/06.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import KiwiControls
import KiwiGraphics

class ViewController: NSViewController
{
	@IBOutlet weak var mGraphicsView: KCGraphicsView!
	private var	   mRepetitiveDrawer: KCRepetitiveDrawer? = nil


	override func viewDidLayout() {
		super.viewDidLayout()

		let bounds = mGraphicsView.bounds

		/* Decide the bounds of element */
		let counts    = 4
		let elmwidth  = min(bounds.size.width, bounds.size.height) / CGFloat(counts)
		let elmbounds = CGRect(x: 0.0, y: 0.0, width: elmwidth, height: elmwidth)

		let vertex = UTVertexLayer(bounds: elmbounds)
		let drawer = KCRepetitiveDrawer(bounds: bounds, elementDrawer: vertex)
		mRepetitiveDrawer = drawer

		for x in 0..<counts {
			for y in 0..<counts {
				let posx = elmwidth * CGFloat(x)
				let posy = elmwidth * CGFloat(y)
				let pos  = CGPoint(x:posx, y:posy)
				drawer.add(location: pos)
			}
		}

		mGraphicsView.drawCallback = {
			(_ context:CGContext, _ bounds:CGRect, _ dirtyRect:CGRect) -> Void in
			drawer.drawContent(context: context, bounds: bounds, dirtyRect: dirtyRect)
		}

		mGraphicsView.mouseEventCallback = {
			(_ event: KCMouseEvent, _ point: CGPoint) -> CGRect in
			drawer.mouseEvent(event: event, at: point)
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

