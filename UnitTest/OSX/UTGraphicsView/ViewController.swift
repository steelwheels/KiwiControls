//
//  ViewController.swift
//  UTGraphicsView
//
//  Created by Tomoo Hamada on 2016/09/18.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import KiwiGraphics
import Cocoa

class ViewController: KCViewController {

	@IBOutlet weak var mGraphicsView: KCGraphicsView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		Swift.print("View did load")

		mGraphicsView.drawCallback = {
			(_ context:CGContext, _ bounds:CGRect, _ dirtyRect:CGRect) -> Void in
			context.setFillColor(KGColorTable.blue2)
			//context.fill(bounds)
			self.drawLine(context: context, bounds: bounds)
			self.drawHexagon(context: context, bounds: bounds)
		}
	}

	private func drawLine(context ctxt:CGContext, bounds bnd: CGRect){
		let endpt = bnd.origin.move(dx: bnd.size.width, dy: bnd.size.height)
		ctxt.setLineWidth(10.0)
		ctxt.setStrokeColor(KGColorTable.red2)
		ctxt.move(to: bnd.origin)
		ctxt.addLine(to: endpt)
		ctxt.strokePath()
	}

	private func drawHexagon(context ctxt:CGContext, bounds bnd: CGRect){
		let h      = bnd.size.height
		let w      = bnd.size.width
		let radius = min(w, h) / 2.0
		let hex    = KGHexagon(center: bnd.center, radius: radius)
		Swift.print("Hexagon: \(hex.description)")
		ctxt.setStrokeColor(KGColorTable.red2)
		ctxt.draw(hexagon: hex)
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

