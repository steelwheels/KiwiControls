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

	override func viewDidLoad() {
		super.viewDidLoad()

		let bounds   = mGraphicsView.bounds
		let counts   = 10
		let elmwidth = min(bounds.size.width / CGFloat(counts), bounds.size.height / CGFloat(counts))
		let elmsize  = CGSize(width: elmwidth, height: elmwidth)

		let drawer = KCRepetitiveDrawer(bounds: bounds, elementSize: elmsize, elementDrawer: {
			(_ context: CGContext, _ size: CGSize) -> Void in
				let radius  = min(size.width, size.height) / 2.0
				let center  = CGPoint(x: radius, y:radius)
				let hexagon = KGHexagon(center: center, radius: radius)
				context.draw(hexagon: hexagon, withGradient: false)
		})
		for x in 0..<counts {
			for y in 0..<counts {
				let posx = elmwidth * CGFloat(x + 1)
				let posy = elmwidth * CGFloat(y + 1)
				let pos  = CGPoint(x:posx, y:posy)
				drawer.add(location: pos)
			}
		}

		// Do any additional setup after loading the view.
		mGraphicsView.drawCallback = {
			(_ context:CGContext, _ bounds:CGRect, _ dirtyRect:CGRect) -> Void in
				drawer.drawContent(context: context, bounds: bounds, dirtyRect: dirtyRect)
		}

		mGraphicsView.mouseEventCallback = {
			(_ event: KCMouseEvent, _ point: CGPoint) -> KCMouseEventResult in
				drawer.mouseEvent(event: event, at: point)
		}

		mRepetitiveDrawer = drawer
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

