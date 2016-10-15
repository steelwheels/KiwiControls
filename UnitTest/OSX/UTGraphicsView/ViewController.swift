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
			context.setFillColor(KGColorTable.blue2.cgColor)
			//context.fill(bounds)
			self.drawLine(context: context, bounds: bounds)

			let (bounds0, bounds1) = bounds.splitByVertically()
			self.drawHexagon(context: context, bounds: bounds0, withGrapdient: false)
			self.drawHexagon(context: context, bounds: bounds1, withGrapdient: true)
		}
	}

	private func drawLine(context ctxt:CGContext, bounds bnd: CGRect){
		let endpt = bnd.origin.move(dx: bnd.size.width, dy: bnd.size.height)
		ctxt.setLineWidth(10.0)
		ctxt.setStrokeColor(KGColorTable.red2.cgColor)
		ctxt.move(to: bnd.origin)
		ctxt.addLine(to: endpt)
		ctxt.strokePath()
	}

	private func drawHexagon(context ctxt:CGContext, bounds bnd: CGRect, withGrapdient wg: Bool){
		let h      = bnd.size.height
		let w      = bnd.size.width
		let radius = min(w, h) / 2.0
		let hex    = KGHexagon(center: bnd.center, radius: radius)
		//Swift.print("Hexagon: \(hex.description)")
		ctxt.setStrokeColor(KGColorTable.red2.cgColor)
		ctxt.draw(hexagon: hex, withGradient: nil)
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

