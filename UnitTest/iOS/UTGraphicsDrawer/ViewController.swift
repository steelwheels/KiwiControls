//
//  ViewController.swift
//  UTGraphicsDrawer
//
//  Created by Tomoo Hamada on 2016/10/02.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import UIKit
import KiwiControls

class ViewController: UIViewController
{
	@IBOutlet weak var mGraphicsView: KCGraphicsView!

	private var mGraphicsDrawer: KCGraphicsDrawer? = nil
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		// Do any additional setup after loading the view, typically from a nib.
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
			(event: KCMouseEvent, point: CGPoint) -> KCMouseEventResult in
			if let drawer = self.mGraphicsDrawer {
				return drawer.mouseEvent(event: event, at: point)
			} else {
				return KCMouseEventResult()
			}
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	private func allocateDrawer() -> KCGraphicsDrawer {
		let drawer = KCGraphicsDrawer()
		return drawer
	}
}

