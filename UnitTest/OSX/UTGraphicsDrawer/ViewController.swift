//
//  ViewController.swift
//  UTGraphicsDrawer
//
//  Created by Tomoo Hamada on 2016/09/24.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import KiwiControls
import KiwiGraphics

class ViewController: NSViewController {

	@IBOutlet private var mGraphicsView: KCGraphicsView!

	private var mGraphicsDrawer: KCGraphicsDrawer? = nil
	
	override func viewDidLayout() {
		super.viewDidLayout()

		// Do any additional setup after loading the view.
		mGraphicsDrawer = allocateDrawer()
		if let drawer = mGraphicsDrawer {
			let layer = KCStrokeDrawer(bounds: mGraphicsView.frame)
			drawer.addLayer(layer: layer)
		}

		mGraphicsView.drawCallback = {
			(context:CGContext, bounds:CGRect, dirtyRect:CGRect) -> Void in
			if let drawer = self.mGraphicsDrawer {
				drawer.drawContent(context: context, bounds: bounds, dirtyRect: dirtyRect)
			}
		}

		mGraphicsView.mouseEventCallback = {
			(event: KCMouseEvent, point: CGPoint) -> CGRect in
			if let drawer = self.mGraphicsDrawer {
				return drawer.mouseEvent(event: event, at: point)
			} else {
				return CGRect.zero
			}
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	private func allocateDrawer() -> KCGraphicsDrawer {
		let drawer = KCGraphicsDrawer()
		return drawer
	}
}

