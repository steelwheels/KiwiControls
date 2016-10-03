//
//  ViewController.swift
//  UTGraphicsView
//
//  Created by Tomoo Hamada on 2016/09/19.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import UIKit
import KiwiControls

class ViewController: UIViewController
{
	@IBOutlet weak var mGraphicsView: KCGraphicsView!

	override func viewDidLoad() {
		super.viewDidLoad()

		mGraphicsView.drawCallback = {
			(context:CGContext, bounds:CGRect, dirtyRect:CGRect) -> Void in
				self.drawContext(context: context, bounds: bounds, dirtyRect: dirtyRect)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	private func drawContext(context ctxt:CGContext, bounds bnd:CGRect, dirtyRect drect:CGRect){
		ctxt.move(to: CGPoint(x: 0.0, y:0.0))
		ctxt.addLine(to: CGPoint(x: bnd.size.width, y: bnd.size.height))
		ctxt.strokePath()

		let radius  = min(bnd.size.width, bnd.size.height)
		let center  = CGPoint(x: bnd.origin.x + radius/2.0, y: bnd.origin.y + radius/2.0)
		let hexagon = KGHexagon(center: center, radius: radius)
		ctxt.draw(hexagon: hexagon)
	}
}



