//
//  ViewController.swift
//  UTGraphicsLayer
//
//  Created by Tomoo Hamada on 2016/10/12.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import UIKit
import KiwiControls

class ViewController: UIViewController
{
	@IBOutlet weak var	mGraphicsView: KCGraphicsView!
	private var		mGraphicsDrawer: KCGraphicsDrawer = KCGraphicsDrawer()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let bounds = mGraphicsView.bounds
		Swift.print("bounds: \(bounds.description)")

		/* Add background */
		let background = KCBackgroundDrawer(bounds: bounds)
		background.color = KGColorTable.black.cgColor
		mGraphicsDrawer.addLayer(layer: background)

		/* Add vertex drawer */
		let vertices = UTVertexLayer(bounds: bounds)
		mGraphicsDrawer.addLayer(layer: vertices)

		mGraphicsView.drawCallback = {
			(context:CGContext, bounds:CGRect, dirtyRect:CGRect) -> Void in
				self.mGraphicsDrawer.drawContent(context: context, bounds:bounds, dirtyRect:dirtyRect)
		}
		mGraphicsView.mouseEventCallback = {
			(event: KCMouseEvent, point: CGPoint) -> KCMouseEventResult in
				return self.mGraphicsDrawer.mouseEvent(event: event, at: point)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

