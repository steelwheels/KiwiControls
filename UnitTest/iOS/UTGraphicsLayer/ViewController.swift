//
//  ViewController.swift
//  UTGraphicsLayer
//
//  Created by Tomoo Hamada on 2016/10/14.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import UIKit
import KiwiControls

class ViewController: UIViewController
{
	private let DO_DEBUG = true

	@IBOutlet weak var mGraphicsView: KCGraphicsView!
	private var mGraphicsDrawer = KCGraphicsDrawer()

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		let bounds = mGraphicsView.bounds

		/* Add background */
		let background = KCBackgroundDrawer(bounds: bounds)
		background.color = KGColorTable.black.cgColor
		mGraphicsDrawer.addLayer(layer: background)

		/* Add vertex layer */
		let vertices   = UTVertexLayer(bounds: bounds)
		mGraphicsDrawer.addLayer(layer: vertices)

		/* Add drawer */
		let drawer = KCStrokeDrawer(bounds: bounds)
		drawer.lineWidth = 10.0
		drawer.lineColor = KGColorTable.gold.cgColor
		mGraphicsDrawer.addLayer(layer: drawer)
		
		mGraphicsView!.drawCallback = {
			(context:CGContext, bounds:CGRect, dirtyRect:CGRect) -> Void in
				if self.DO_DEBUG {
					Swift.print("ViewController.drawCallback: bounds:\(bounds.description) dirty:\(dirtyRect.description)")
				}
				self.mGraphicsDrawer.drawContent(context: context, bounds: bounds, dirtyRect: dirtyRect)
		}

		mGraphicsView!.mouseEventCallback = {
			(event: KCMouseEvent, point: CGPoint) -> CGRect in
			return self.mGraphicsDrawer.mouseEvent(event: event, at: point)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

